% P = [0 0; 1 1; 1.5 0.5; 1.5 -0.5; 1.25 0.3; 1 0; 1.25 -0.3; 1 -1];
% [k,av] = convhull(P);
%
% h = flygrab();
% [image , maskedRGB] = createMask(h);
% [blobMeasurements, numberOfObjects] = shape_finder(image );

% bbmovedeg(rob, [0 0 0 0 0 0]);
matrix = coordinates_transformation;
last_deg = [0 0 0 0 0 0];
vektor = [600 550.255793991416 1]'; 
% 450 100 lijevi cosak prema staklu visina 100
% 450 800 desni cosak prema staklu visina 100
% 350 500 ispruzen po sredini visina 100
% [600 550.255793991416 1] najbolji

rob_coord = matrix * vektor;
a = rob_coord(1:2,:)';

next_pos = [a 150 0 90 80.655328097900310];
% bbmovedeg(rob, [0 0 -90 0 -90 0]); % upitnik pozicija

sol = best_ikt(next_pos, last_deg, rob);
last_pos = next_pos;
last_deg = sol;

bbmovedeg(rob, sol);
bbwaitforready(rob);
