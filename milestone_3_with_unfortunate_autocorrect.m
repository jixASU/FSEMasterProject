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
threshold1 = 12.5;

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
    distance = brick.UltrasonicDist(2)


    
    %Here comes the auto correct
    %sorry, it was necessary
    lSpeed = -50
    rSpeed = -50
    
   %plz keep car doesn't always turn exactly 90 degress
   
    if distance < 47   %if our wall is within a reasonable distance, autocorrect
                       %(40 might be is too far, so probalby something closer)
        while true    %it's needed and we break the loop at specific conditions.plz don't change or whole code breals
        
        distance = brick.UltrasonicDist(2) %collect the distance before moving
        brick.MoveMotor(LM, lSpeed); %move the car for .25 secnds
        brick.MoveMotor(RM, rSpeed); %autoadjust kinda requires l and r motors to move at different speeds while we loop
                                     %so this inefficient boiler plate is kinda needed
        pause(.25) %move car for .25 seconds to record our new distance
        distanceNew = brick.UltrasonicDist(2) %see the new distance from the wall (new distance). Used to see how far the distance between the car and wall has changed
        
        
        %basically in java, with float values, if u want to check if float1 = val
        %then we use abs(float1 - val ) <= epsilon (which in this case has to be '1' so we don't autocorrect evry seconds
        %see logical if statement below
        
        if (abs(distanceNew-distance) > 1) %are we drifting at all?
            %if so...
            if (distanceNew < distance) %are we drifitng away?
                %weird complicated autocorrection
                %just move back and forth in a very specific way until the car is pointed straight
                %better to understand visually
                
                
                
                brick.StopMotor(BM);
                lSpeed = -50
                rSpeed = rSpeed - 5;
                brick.MoveMotor(LM, lSpeed);
                brick.MoveMotor(RM, rSpeed);
                pause(.75)
                brick.MoveMotor(LM, -rSpeed);
                brick.MoveMotor(RM, -lSpeed);
                pause(1)
                brick.StopMotor(BM);
                
            elseif (distanceNew > distance) %are we drifitng toward the wall?
                %also so some weird complicated autocorrection
                %better to udnerstand visually
                %sometimes used of autocorrect overshot and we are not entirely straight
                %everything straightens out eventually so don'w worry about it
                
                brick.StopMotor(BM);
                rSpeed = -50
                lSpeed = rSpeed - 5;
                brick.MoveMotor(LM, lSpeed);
                brick.MoveMotor(RM, rSpeed);
                pause(.75)
                brick.MoveMotor(LM, -rSpeed);
                brick.MoveMotor(RM, -lSpeed);
                pause(1)
                brick.StopMotor(BM);

            end
            
        else
            rSpeed = -50;
            lSpeed = -50;
            break;
        end
    end
end

%END OF AUTO CORRECTION

%{
tldr: The code uses a different metric to straighten out (That simply deals with how straight the bot is). (Much easier to set up than using a gyro which we don't have enough time for anyways.)
Longer description:
The earlier code we used to autocorrect in implementation 1 and 2 used distance from the wall as a metric for moving "straight"
In tose cases, the car would auto-adjust iself bu turning into the wall (i.e slow down one fo the motors in order to turn).
The problem with that is that even if the car was x-distance from the wall, it was at an angle at that point of time such that it will end up going too far from the wall and be in a wanky turning motion.

This code however uses changes in distance.
Whereever the car my be, as long as it's distance from the wall doesn't change too much it's good.
Also, instead of auto correct in ways before, we use a special back and forth motion to accomplish this.
This means that the car will always be pointing straight after being auto-corrected.
%}


    % Move forward
    brick.MoveMotor(LM, x);
    brick.MoveMotor(RM, y);
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
    end
    % ADJUST
    

    % turn Left on button pressed
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
