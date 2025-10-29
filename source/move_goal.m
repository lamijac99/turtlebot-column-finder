function move_goal(goal_coord, height_goal, rob, pack_coord)
matrix = coordinates_transformation;
last_deg = [0 0 0 0 0 0];

vektor = [goal_coord 1]';
rob_coord = matrix * vektor;
a = rob_coord(1:2,:)';

if pack_coord(1) < 550 && pack_coord(2) > 550
    bbmovedeg(rob, [0 0 0 0 0 0]);
    bbwaitforready(rob);
else
    lift = [a 300 0 90 0];
    sol2 = best_ikt(lift, last_deg, rob);
    if isnan(sol2)
        sol2 = last_deg;
    end
    bbmovedeg(rob, sol2);
    bbwaitforready(rob);
end

next_pos = [a height_goal 0 90 0];
sol = best_ikt(next_pos, last_deg, rob);

bbmovedeg(rob, sol);
bbwaitforready(rob);

bbgrip(rob, -0.1);
bbwaitforready(rob);

lift = [a 300 0 90 0];
sol2 = best_ikt(lift, last_deg, rob);
if isnan(sol2)
    sol2 = last_deg;
end
bbmovedeg(rob, sol2);
bbwaitforready(rob);

end
