global key
InitKeyboard();

while 1
    pause(0.1);
    switch key
        case 'uparrow'
            display('up');
            brick.MoveMotor('A', 50);
            brick.MoveMotor('D', 50);
        case 'downarrow'
            display('down');
            brick.MoveMotor('A', -50);
            brick.MoveMotor('D', -50);

        case 'leftarrow'
            display('left');
            brick.MoveMotor('A', 25);
            brick.MoveMotor('D', 50);
        case 'rightarrow'
            display('right');
            brick.MoveMotor('A', 50);
            brick.MoveMotor('D', 25);
        case 0
            display('not moving')
            brick.MoveMotor('A', 0);
            brick.MoveMotor('D', 0);
    end
end

CloseKeyboard();