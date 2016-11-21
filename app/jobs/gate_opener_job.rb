class GateOpenerJob
  include SuckerPunch::Job

  def perform(access_params = {})
    SuckerPunch.logger.debug "Opening gate (triggering GPIO PIN ##{ENV['GATE_GPIO_PIN']})"
    SuckerPunch.logger.debug access_params.inspect

    if rpi_gpio_available?
      require 'rpi_gpio'
      open_gate
    else
      SuckerPunch.logger.warn 'RPi GPIO missing!'
    end

    Access.create access_params
  end

  private

  def rpi_gpio_available?
    Gem::Specification.find_all_by_name('rpi_gpio').any?
  end

  def open_gate
    RPi::GPIO.set_numbering :board
    RPi::GPIO.setup ENV['GATE_GPIO_PIN'], as: :output
    RPi::GPIO.set_high ENV['GATE_GPIO_PIN']
    sleep 1
    RPi::GPIO.set_low ENV['GATE_GPIO_PIN']
    RPi::GPIO.reset
  end
end
