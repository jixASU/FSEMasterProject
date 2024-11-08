brick.SetColorMode(1, 4)
global key
InitKeyboard();

stopCar = false;
threshold = 85;

while stopCar == false

    %Move forward
    brick.MoveMotor('A', -50);
    brick.MoveMotor('D', -50);
    
    % Save the color it sees
    color = brick.ColorCode(4);

if (color == 3) %If it is green it will stop and beep 3 times
        brick.StopMotor('AD')
        pause(.2)
        brick.beep()
        pause(.2)
        brick.beep
        pause(.2)
        brick.beep()
        pause(.4)
        break
end
    % MAKE CHANGES TO DISTANCE SENSOR
    distance = brick.UltrasonicDist(2);
    
    if (distance > threshold)
        brick.MoveMotor('A', 0);
        brick.MoveMotor('D', 0);
        pause(.5)
        brick.MoveMotor('A', -50);
        brick.MoveMotor('D', -50);
        pause(1)
        distance = brick.UltrasonicDist(2);
      
        if (distance > threshold)
            % Turns, stops, then goes straight a bit
            brick.MoveMotor('A', 50);
            brick.MoveMotor('D', -50);
            pause(.85);
            brick.MoveMotor('A', -20);
            brick.MoveMotor('D', -20);
        end
      
        
    elseif distance < 5
        brick.MoveMotor('A', -50);
            brick.MoveMotor('D', -45);
            pause(.5);
    end

    if (brick.TouchPressed(1) == 1) % Will turn left if the button is pressed
        brick.MoveMotor('A', 0);
        brick.MoveMotor('D', 0);
        pause(.5)
        brick.MoveMotor('A', 50);
        brick.MoveMotor('D', 50);
        pause(.5)
        brick.MoveMotor('A', -50);
        brick.MoveMotor('D', 50);
        pause(.85)
    end
    
end
