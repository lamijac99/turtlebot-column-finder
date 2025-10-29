function movement_package(pack_coord, height, rob, angle)
last_deg = [0 0 0 0 0 0];
matrix = coordinates_transformation;

vektor = [pack_coord 1]';
rob_coord = matrix * vektor;
a = rob_coord(1:2,:)';

bbgrip(rob, -0.1);
bbwaitforready(rob);

next_pos = [a 250 0 90 0];
sol = best_ikt(next_pos, last_deg, rob);

if ~isnan(sol)
    bbmovedeg(rob, sol);
    bbwaitforready(rob);
end

next_pos = [a height 0 90 angle];
sol = best_ikt(next_pos, last_deg, rob);

bbmovedeg(rob, sol);
bbwaitforready(rob);

bbgrip(rob, 1);
bbwaitforready(rob);
bbwaitforready(rob);

lift = [a 300 0 90 0];
sol2 = best_ikt(lift, last_deg, rob);
if isnan(sol2)
    sol2 = last_deg;
end
bbmovedeg(rob, sol2);
bbwaitforready(rob);

end
