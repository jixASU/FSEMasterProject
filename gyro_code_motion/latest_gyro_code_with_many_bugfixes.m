%Since the last FSE class 11:25, absolutely no modifications were made to the code so far other than a few comments


%{
Cable for wheelchair grabber gets in the way (not needed rn so toher than
that other bugs:

button turns can be iffy (the bot doesn;t give iself enough room to bump
into a wall. Instead, bot should adjust both ways.

TODO:
Fix scooper
Fix motors as car turns away from right wall (withotu autocorrecting immediately

-FIX the wole autocorrect code from the ground up

%}

%gryo can always be buggy unless we ensure that a new brick variable is delcared before hand
if (exist("brick"))
    clear("brick");
end
brick = ConnectBrick("EV3KLM");


brick.SetColorMode(1, 4)
global key
InitKeyboard();

stopCar = false;
threshold = 82;

%list of cors with their associated number
colorDestinationArr = ["0" "1" "2" "3" "4" "5" "6" "7"; "NaN" "Black" "Blue" "Green" "Yellow" "Red" "White" "Brown"];

%check of global variable for starting destination exists
if (~exist('colorStart', 'var')) %if not, make it
    global colorStart 
    colorStart = "blue";
elseif isempty(colorStart) % if empty, give it something
    colorStart = "blue";
end
for i = 1 : 1 : 8 %You know, that color array up there that seemed useless. Well now we itterate through it
    colorz = upper(colorDestinationArr(2,i)); %value extracted from array
    colorStart = upper(colorStart); %our start color
    if (colorz == colorStart) %does this color match somehting in the aray
        colorStartInt = str2double(colorDestinationArr(1,i)); %it does? then feed our colorStartInt with the color integer
    end
end

if (~exist('colorDestination', 'var'))
    global colorDestination 
    colorDestination = "green";
elseif isempty(colorDestination)
    colorDestination = "green";
end
for i = 1 : 1 : 8
    colorz = upper(colorDestinationArr(2,i));
    colorDestination = upper(colorDestination);
    if (colorz == colorDestination)
        colorDestinationInt = str2double(colorDestinationArr(1,i));
    end
end

% Left Motor, Right Motor, Both Motor, and Scooper global variables, in case of port switch
global LM
global RM
global BM
global S
LM = 'C'
RM = 'A'
BM = 'AC'
S = 'D'
turnAngle = 87;
lSpeed = -50;
rSpeed = -50;
pause(.5);
brick.GyroCalibrate(3);
pause(5);
% MAIN LOOP
while (~stopCar)
    
    angle = brick.GyroAngle(3)

    % Move forward
    brick.MoveMotor(LM, lSpeed);
    brick.MoveMotor(RM, rSpeed);
    
    % Save the color it sees
    color = brick.ColorCode(4);
    
    if (color == 5) %If it is red it will stop
        brick.StopMotor(BM)
        pause(1) 
    elseif ( color == colorStartInt )
        colorIntTemp = colorDestinationInt;
        
        % Color is green or blue

        % TODO: SWITCH TO MANUAL CONTROL FOR PICKUP
        stopCar = false;
        
    end
    
    % MAKE CHANGES TO DISTANCE SENSOR
    distance = brick.UltrasonicDist(2);

    % TURN RIGHT
    if (distance > threshold)
        
        
        brick.MoveMotor(BM, 0);
        pause(.5) %stop motor and pause for .5 seconds

        %if we see gap, move forward a litte bit
        brick.MoveMotor(BM, -25);
        pause(1.25)%time increased form 1 to 1.25 to actually allow bot to turn
                        %without this, bot gets caught in walls while turning
        brick.MoveMotor(BM, 0);
        pause(.5)
        distance = brick.UltrasonicDist(2);
        %if we still see a gap, turn as follows
        if (distance > threshold)
            brick.StopMotor(BM);
            pause(.5)
            brick.GyroCalibrate(3);
            pause(.5)

            angle = brick.GyroAngle(3)
            
            while ((angle > -turnAngle) | (isnan(angle)))
                brick.MoveMotor(LM, -20);
                brick.MoveMotor(RM, 20);
                angle = brick.GyroAngle(3)
                if ((angle >= 180) | (angle <= -180))
                    brick.StopMotor(BM);
                    pause(.5)
                    brick.GyroCalibrate(3);
                    pause(.5)
                end
                
            end
            brick.StopMotor(BM);
            pause(.5)
            brick.GyroCalibrate(3);
            pause(.5)
            brick.MoveMotor(BM, -20);
        end
    end
    % ADJUST
    

    % turn Left on button pressed
     if (brick.TouchPressed(1) == 1)
        brick.beep();
        brick.beep();
        brick.MoveMotor(BM, 0);
        pause(.5)
        brick.GyroCalibrate(3);
        pause(.5)

        brick.MoveMotor(BM, 0);
        pause(.5)
        brick.MoveMotor(BM, 50);
        pause(.5)
        brick.MoveMotor(BM, 0);
        pause(.5)
        brick.GyroCalibrate(3);
        pause(.5)
        angle = brick.GyroAngle(3)
        
        while ((angle < turnAngle) | (isnan(angle)))
            brick.MoveMotor(LM, 20);
            brick.MoveMotor(RM, -20);
            angle = brick.GyroAngle(3)
            if ((angle >= 180) | (angle <= -180))
                    brick.StopMotor(BM);
                    pause(.5)
                    brick.GyroCalibrate(3);
                    pause(.5)
            end
              
        end
        brick.StopMotor(BM);
        pause(.5)
        brick.GyroCalibrate(3);
        pause(.5)
        brick.StopMotor(BM);
        pause(.5)
     end
   
end

runKey = true;
while (runKey)
    pause(0.1)
    switch key
        case 'uparrow'
            brick.MoveMotor(BM, -50);
        case 'downarrow'
            brick.MoveMotor(BM, 50);
        case 'leftarrow'
            brick.MoveMotor(RM, -25);
            brick.MoveMotor(LM, 25);
        case 'rightarrow'
            brick.MoveMotor(RM, 25);
            brick.MoveMotor(LM, -25);
        case 'w'
            brick.MoveMotor(S, 5);
        case 'd'
            brick.MoveMotor(S, 10);
        case 'a'
            brick.MoveMotor(S, -10);
        case 's'
            brick.MoveMotor(S, -5);
        
        case 'e'
            disp('Manual Control Ended');
            runKey = false;
            
        case 0
            brick.StopMotor('D');
            brick.StopMotor(BM);
            
    end
end

brick.StopMotor(BM);
pause(.5)
brick.GyroCalibrate(3);
pause(.5)
brick.StopMotor(BM);
pause(.5)
stopCar = false;

while (~stopCar)
    angle = brick.GyroAngle(3)

    % Move forward
    brick.MoveMotor(LM, lSpeed);
    brick.MoveMotor(RM, rSpeed);
    %brick.beep();
    % Save the color it sees
    color = brick.ColorCode(4);
    
    if (color == 5) %If it is red it will stop
        brick.StopMotor(BM)
        pause(1) 
    elseif ( color == colorDestinationInt )
        colorIntTemp = colorDestinationInt;
        
        % Color is green or blue

        % TODO: SWITCH TO MANUAL CONTROL FOR PICKUP
        stopCar = true;
    end

    % MAKE CHANGES TO DISTANCE SENSOR
    distance = brick.UltrasonicDist(2);

    % TURN RIGHT
    if (distance > threshold)
        
        
        brick.MoveMotor(BM, 0);
        pause(.5) %stop motor and pause for .5 seconds

        %if we see gap, move forward a litte bit
        brick.MoveMotor(BM, -50);
        pause(1.25)%time increased form 1 to 1.25 to actually allow bot to turn
                        %without this, bot gets caught in walls while turning
        brick.MoveMotor(BM, 0);
        pause(.5)
        distance = brick.UltrasonicDist(2);
        %if we still see a gap, turn as follows
        if (distance > threshold)
            brick.StopMotor(BM);
            pause(.5)
            brick.GyroCalibrate(3);
            pause(.5)

            angle = brick.GyroAngle(3)
            
            while ((angle > -turnAngle) | (isnan(angle)))
                brick.MoveMotor(LM, -20);
                brick.MoveMotor(RM, 20);
                angle = brick.GyroAngle(3)
                if ((angle >= 180) | (angle <= -180))
                    brick.StopMotor(BM);
                    pause(.5)
                    brick.GyroCalibrate(3);
                    pause(.5)
                end
                
            end
            brick.StopMotor(BM);
            pause(.5)
            brick.GyroCalibrate(3);
            pause(.5)
            brick.MoveMotor(BM, -20);
        end
    end
    % ADJUST
    

    % turn Left on button pressed
     if (brick.TouchPressed(1) == 1)
        

        brick.MoveMotor(BM, 0);
        pause(.5)
        brick.MoveMotor(BM, 50);
        pause(.5)
        brick.MoveMotor(BM, 0);
        pause(.5)
        brick.GyroCalibrate(3);
        pause(.5)
        angle = brick.GyroAngle(3)

        while ((angle < turnAngle) | (isnan(angle)))
            brick.MoveMotor(LM, 20);
            brick.MoveMotor(RM, -20);
            angle = brick.GyroAngle(3)
            if ((angle >= 180) | (angle <= -180))
                    brick.StopMotor(BM);
                    pause(.5)
                    brick.GyroCalibrate(3);
                    pause(.5)
            end
              
        end
        brick.StopMotor(BM);
        pause(.5)
        brick.GyroCalibrate(3);
        pause(.5)
        brick.StopMotor(BM);
        pause(.5)
     end
   
end

runKey = true;
while (runKey)
    pause(0.1)
    switch key
        case 'uparrow'
            brick.MoveMotor(BM, -50);
        case 'downarrow'
            brick.MoveMotor(BM, 50);
        case 'leftarrow'
            brick.MoveMotor(RM, -25);
            brick.MoveMotor(LM, 25);
        case 'rightarrow'
            brick.MoveMotor(RM, 25);
            brick.MoveMotor(LM, -25);
        case 'w'
            brick.MoveMotor(S, 5);
        case 'd'
            brick.MoveMotor(S, 10);
        case 'a'
            brick.MoveMotor(S, -10);
        case 's'
            brick.MoveMotor(S, -5);
        
        case 'e'
            disp('Manual Control Ended');
            runKey = false;
            
        case 0
            brick.StopMotor('D');
            brick.StopMotor(BM);
            
    end
end

brick.StopMotor('D');
brick.StopMotor(BM);
CloseKeyboard();
