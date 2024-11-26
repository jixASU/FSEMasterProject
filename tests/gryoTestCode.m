brick.StopMotor(BM);
brick.StopMotor(S);
brick.GyroCalibrate(3);
global key;
InitKeyboard();
pause(5);
while true
   
    pause(0.1);
    switch key
        case 'e'
            brick.GyroCalibrate(3);
            brick.StopMotor(BM);
            break;
        case 0
            angle = brick.GyroAngle(3)

            while ((angle < 90) | (isnan(angle)))
                brick.MoveMotor(LM, 20);
                brick.MoveMotor(RM, -20);
                angle = brick.GyroAngle(3)

                
            end
            brick.StopMotor(BM);
            break;

    end

    

    

end
