%{
Cable for wheelchair grabber gets in the way (not needed rn so toher than
that other bugs:

button turns can be iffy (the bot doesn;t give iself enough room to bump
into a wall. Instead, bot should adjust both ways.
%}



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
    colorStart = "green";
elseif isempty(colorStart) % if empty, give it something
    colorStart = "green";
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
    colorDestination = "blue";
elseif isempty(colorDestination)
    colorDestination = "blue";
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

% MAIN LOOP
while (~stopCar)
    % Move forward
    brick.MoveMotor(BM, -50);
    %brick.beep();
    % Save the color it sees
    color = brick.ColorCode(4);
    
    if (color == 5) %If it is red it will stop
        brick.StopMotor(BM)
        pause(1) 
    elseif ( color == colorStartInt )
        colorStartInt = colorDestinationInt;
        % Color is green or blue

        % TODO: SWITCH TO MANUAL CONTROL FOR PICKUP
        while (1)
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
                    brick.MoveMotor(BM, -25);
                case 'w'
                    brick.MoveMotor(S, 5);
                case 'd'
                    brick.MoveMotor(S, 10);
                case 'a'
                    brick.MoveMotor(S, -10);
                case 's'
                    brick.MoveMotor(S, -5);
                
                case 'e'
                    stopCar = false;
                    disp('Manual Control Ended');
                    break;
                case 0
                    brick.StopMotor('D');
                    brick.StopMotor(BM);
                    
            end
        end
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
        distance = brick.UltrasonicDist(2);

        %if we still se a gap, actually turn
        if (distance > threshold)
            brick.MoveMotor(LM, -50);
            pause(.25)
            % Turns, stops, then goes straight a bit
            brick.MoveMotor(RM, 50);
            brick.MoveMotor(LM, -50);
            pause(.85); 
            brick.MoveMotor(BM, -20);
        end
    % ADJUST
    elseif distance < 5
        brick.MoveMotor(LM, -50);
            brick.MoveMotor(RM, -45);
            pause(.5);
    end

    % BUTTON PRESSED TURN RIGHT
    if (brick.TouchPressed(1) == 1)
        brick.MoveMotor(BM, 0);
        pause(.5)
        brick.MoveMotor(BM, 50);
        pause(.5)
        brick.MoveMotor(RM, -50);
        brick.MoveMotor(LM, 50);
        pause(0.777271212626);
    end
end


brick.StopMotor('D');
brick.StopMotor(BM);
CloseKeyboard();
