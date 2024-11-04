%brick.SetColorMode(1, 4)
%move cables if not going straight

global key
colorDestinationArr = ["0" "1" "2" "3" "4" "5" "6" "7"; "NaN" "Black" "Blue" "Green" "Yellow" "Red" "White" "Brown"];

if (~exist('colorDestination', 'var'))
    global colorDestination 
    colorDestination = "blue";
elseif isempty(colorDestination)
    colorDestination = "blue"
end
InitKeyboard();
 x = -50
y = -50
stopCar = false;
threshold = 19.5;
brick.SetColorMode(4,2);

for i = 1 : 1 : 8
    colorz = upper(colorDestinationArr(2,i))
    colorDestination = upper(colorDestination)
    if (colorz == colorDestination)
        colorDestinationInt = str2double(colorDestinationArr(1,i))
    end
end
while stopCar == false
    
    %Move forward
    brick.MoveMotor('AD', -50);
    color = brick.ColorCode(4);
    display(color)
    if (color == 5)
        brick.StopMotor('AD')
        pause(1)
        
    elseif (color == 2) %blue
        brick.StopMotor('AD')
        pause(.2)
        brick.beep()
        pause(.2)
        brick.beep
        pause(.6)
        break
        
    elseif (color == 3) %green
        brick.StopMotor('AD')
        pause(.2)
        brick.beep()
        pause(.2)
        brick.beep
        pause(.2)
        brick.beep()
        pause(.4)
        break
        %{
    elseif (color == colorDestinationInt) %green
        brick.StopMotor('AD')
        pause(.2)
        brick.beep()
        pause(.2)
        brick.beep
        pause(.2)
        brick.beep()
        pause(.4)
        break
         %}
    end
    

    %save distance
    distance = brick.UltrasonicDist(2);


    tooFar = 80;
    if (distance >= tooFar)
        brick.StopMotor('AD');
        pause(.1)
        brick.MoveMotor('AD', -50);

        % Turn Left
        
        pause(.5)
        distance = brick.UltrasonicDist(2);
        if (distance >= tooFar)
            brick.MoveMotor('A', 50);
            brick.MoveMotor('D', -50);
            pause(.75)
        end
        % Kill motor
        brick.StopMotor('AD');
        pause(.01);
        %brick.MoveMotor('AD', -50);
        pause(2);
    elseif (distance >= threshold + 1)
        display("turning right")

        
        brick.MoveMotor('A', x);
        brick.MoveMotor('D', y);
        y = -50
        if (x < -35)
            x = x + 5
        end
        
       
    elseif (distance <= threshold - 1)
        display("turning right")
        x = -50
        
        brick.MoveMotor('A', x);
        brick.MoveMotor('D', y);
        if (y < -35)
            y = y +5
        end
        
    else
        brick.MoveMotor('AD', -50);
        x = -50
        y = -50
    end

    % turn Left on button pressed
    if (brick.TouchPressed(1) == 1);

        % stop motor and move backward
        display("turn");
        brick.StopMotor('AD');
        pause(.5)
        brick.MoveMotor('AD', 50);

        % Turn Left
        
        pause(.5)
        brick.MoveMotor('A', -65);
        brick.MoveMotor('D', 65);
        pause(.55)

        % Kill motor
        brick.StopMotor('AD');
        pause(1);
    end   
end
brick.StopMotor('AD');






%{
check if it can go left
if left open
    turn left and go straight until hit wall
else if right open
    turn right and go straight until hit wall
else if straight open
    go straight until hit wall
else if left, straight, or right not open
    reset (turn back and move forward some)
break
%}