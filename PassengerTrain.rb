class PassengerTrain < Train
  def car_connect(car)
    @cars << car if car.is_a?(PassengerCar)
  end
end

