global key
InitKeyboard();
stopCar = true;
% KEYBOARD CONTROLS
while ~stopCar
    pause(0.1)
    switch key
        case 'uparrow'
            disp('forward');
            brick.MoveMotor('AC', -50);
        case 'downarrow'
            disp('backward');
            brick.MoveMotor('AC', 50);
        case 'leftarrow'
            disp('left turn');
            brick.MoveMotor('A', -25);
            brick.MoveMotor('C', 25);
        case 'rightarrow'
            disp('right turn');
            brick.MoveMotor('A', 25);
            brick.MoveMotor('C', -25);
        case 'w'
            disp('scopper up');
            brick.MoveMotor('D', 5);
        case 3
            disp('scopper up');
            brick.MoveMotor('D', 5);
        case 'a'
            disp('scooper down');
            brick.MoveMotor('D', -5);
        case 's'
            disp('scooper down');
            brick.MoveMotor('D', -5);
        case 'e'
            stopCar = false;
            disp('break');
            break;
        case 0
            %disp('not moving')
            brick.StopMotor('D');
            brick.StopMotor('AC');
            
    end
end
brick.StopMotor('D');
brick.StopMotor('AC');
CloseKeyboard();