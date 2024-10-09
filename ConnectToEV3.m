%Aarush Murari, John Ixcoy, Renee Cardoza Leon , Sebastian Fragoso
if ~(exist("brick") == 1) 
    brick = ConnectBrick('QWE');
end

%InitKeyboard();
%global key
amIDeadYet = 1;

while brick.TouchPressed(1) == 0
    pause(0.01)
    %%switch key
        %%case 'uparrow'
            %%amIdeadYet = 0
            
    %%end
    %%We're moving the motor at a speed of 50 because button was not pressed
    %%brick.MoveMotor('A', 50);
    %%brick.MoveMotor('D', 50);
    
end
%Button pressed, kill the motor!
%%brick.MoveMotor('A', 0)
%%  brick.MoveMotor('D', 0)

display("Killed the motor!")