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
clear("brick");
global brick; %The following line was added without actually testing anything. Making it global shouldn;t do much, but there is a slight possibility it might be a bug. Please comment it out if you find it to be buggy.
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
    %brick.beep();
    % Save the color it sees
    color = brick.ColorCode(4);
    
    if (color == 5) %If it is red it will stop
        brick.StopMotor(BM)
        pause(1) 
    elseif ( color == colorStartInt )
        colorIntTemp = colorDestinationInt;
        colorStartInt = colorDestinationInt;
        colorDestinationInt = colorIntTemp;
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
        

        %if we still see a gap, turn as follows
        if (distance > threshold)
 
            brick.MoveMotor(BM, -50); %move forward for .75 seconds
            pause(.75)
            
            brick.MoveMotor(BM, 0); %stop for .5 seconds
            pause(.5)
            
           

            if (distance > threshold) %Sometimes, when we go forward, we
                                      %miss a gap. Better to check instead
                                      %of ramming into a wall
                                    
                brick.StopMotor(BM);
                pause(.5)
                brick.GyroCalibrate(3);
                pause(.5)

                angle = brick.GyroAngle(3)
            
                while ((angle > -90) | (isnan(angle)))
                    brick.MoveMotor(LM, -20);
                    brick.MoveMotor(RM, 20);
                    angle = brick.GyroAngle(3)
              
                end
                brick.StopMotor(BM);
                pause(.5)
                brick.MoveMotor(BM, -20);
            end
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

        while ((angle < 90) | (isnan(angle)))
            brick.MoveMotor(LM, 20);
            brick.MoveMotor(RM, -20);
            angle = brick.GyroAngle(3)
              
        end
        brick.StopMotor(BM);
        pause(.5)
     end



    

    %All autocorrect has been commented out
    %If it is even necessary, we can use a gyro autocorrect but for now the car seems to perform well.
    
    
    
    %{
    %Here comes the auto correct
    %sorry, it was necessary
    distance = brick.UltrasonicDist(2)
    lSpeed = -50
    rSpeed = -50
    if ((distance < 40) | (distance > 250))    %it's needed and we break the loop at specific conditions.plz don't change or whole code breals
        
        distance = brick.UltrasonicDist(2) %collect the distance before moving
        brick.MoveMotor(LM, lSpeed); %move the car for .25 secnds
        brick.MoveMotor(RM, rSpeed); %autoadjust kinda requires l and r motors to move at different speeds while we loop
                                     %so this inefficient boiler plate is kinda needed
        pause(.25) %move car for .25 seconds to record our new distance
        distanceNew = brick.UltrasonicDist(2) %see the new distance from the wall (new distance). Used to see how far the distance between the car and wall has changed
        if ((distance > 40) && (distance < 255))
            brick.StopMotor(BM);
            break;
        end
        
        %basically in java, with float values, if u want to check if float1 = val
        %then we use abs(float1 - val ) <= epsilon (which in this case has to be '1' so we don't autocorrect evry seconds
        %see logical if statement below
        
        if ((abs(distanceNew-distance) > 1) & ((distance < 40) | (distance > 250)))%are we drifting at all?
            %if so...
            if ((distanceNew < distance) & ((distance < 40) | (distance > 250))) %are we drifitng away?
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
                
            elseif ((distanceNew > distance) & ((distance < 40) | (distance > 250))) %are we drifitng toward the wall?
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
        end
    end
    %}
    
   %plz keep car doesn't always turn exactly 90 degress
      %if our wall is within a reasonable distance, autocorrect
                       %(40 might be is too far, so probalby something closer)
   
end

brick.StopMotor('D');
brick.StopMotor(BM);
CloseKeyboard();
