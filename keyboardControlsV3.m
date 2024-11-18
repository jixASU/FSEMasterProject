brick.SetColorMode(1, 4)
global key
InitKeyboard();

stopCar = true;
threshold = 85;

%list of cors with their associated number
colorDestinationArr = ["0" "1" "2" "3" "4" "5" "6" "7"; "NaN" "Black" "Blue" "Green" "Yellow" "Red" "White" "Brown"];


%check of global variable for starting destination exists
if (~exist('colorStart', 'var')) %if not, make it
    global colorStart 
    colorStart = "green";
elseif isempty(colorStart) % if empty, give it something
    colorStart = "green"
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


% While loop for going to destination



% While loop for dropping off
while (~stopCar)
    % Move forward
    brick.MoveMotor('AC', -50);
    brick.beep();e
    % Save the color it sees
    color = brick.ColorCode(4);
    
    if (color == 5) %If it is red it will stop
        brick.StopMotor('AC')
        pause(1)
        
    end

    % MAKE CHANGES TO DISTANCE SENSOR
    distance = brick.UltrasonicDist(2);
    
    if (distance > threshold)
        brick.MoveMotor('AC', 0);
        pause(.5)
        %if we see gap, move forward a litte bit
        brick.MoveMotor('AC', -50);
        pause(1)
        distance = brick.UltrasonicDist(2);

        %if we still se a gap, actually turn
        if (distance > threshold)
            % Turns, stops, then goes straight a bit
            brick.MoveMotor('A', 50);
            brick.MoveMotor('C', -50);
            pause(.85);
            brick.MoveMotor('AC', -20);
        end
      
    elseif distance < 5
        brick.MoveMotor('A', -50);
            brick.MoveMotor('C', -45);
            pause(.5);
    end

    if (brick.TouchPressed(1) == 1) % Will turn left if the button is pressed
        brick.MoveMotor('AC', 0);
        pause(.5)
        brick.MoveMotor('AC', 50);
        pause(.5)
        brick.MoveMotor('A', -50);
        brick.MoveMotor('C', 50);
        pause(.85)
    end
end

while (1)
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