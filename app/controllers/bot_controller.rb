class BotController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  # include Telegram::Bot::UpdatesController::TypedUpdate

  # IMPORTANT: enable caching in order to use contexts by adding to the environment
  # config.telegram_updates_controller.session_store = :memory_store, { size: 64.megabytes }
  # replace :memory_store with whatever store you want to use (e.g. Redis)

  def start
    respond_with :message,
                 reply_markup: {
                   keyboard: [[
                     { text: 'Invia Contatto', request_contact: true }
                   ]],
                   resize_keyboard: true,
                   one_time_keyboard: true
                 },
                 text: <<-TXT.strip_heredoc
                   Per iniziare ad usare il bot devi verificare la tua autorizzazione.
                   Premi il pulsante "Invia Contatto" per iniziare.
                 TXT
    save_context :checking_authorization
  end

  context_handler :checking_authorization do
    if valid_phone_number?
      User.find_by(phone_number: update['message']['contact']['phone_number']) do |user|
        user.update_attribute :telegram_user_id, from['id']
        respond_with :message,
                     text: 'Ottimo! Il tuo numero è autorizzato',
                     reply_markup: {
                       inline_keyboard: [
                         [
                           { text: 'Apri', callback_data: user.id.to_s }
                         ]
                       ],
                       resize_keyboard: true,
                       one_time_keyboard: false
                     }
      end
    else
      respond_with :message, text: 'Eh no! Il tuo numero non può aprire il cancello'
    end
  end

  def callback_query(user_id)
    if User.where(id: user_id).exists? &&
       User.find(user_id).telegram_user_id == from['id']
      GateOpenerJob.perform_async(user: User.find(user_id), openedWith: 'Telegram')
      answer_callback_query 'Apro...'
    else
      answer_callback_query 'Ooops! Forse questo numero non è autorizzato?', show_alert: true
    end
  end

  def action_missing(action, *_args)
    if command?
      respond_with :message, text: "Non so cosa sia #{action}"
    else
      respond_with :message, text: "#{action}? Non so cosa fare"
    end
  end

  private

  def valid_phone_number?
    return false unless update['message']['contact']
    phone_number = update['message']['contact']['phone_number']
    User.where(phone_number: phone_number).exists?
  end
end
