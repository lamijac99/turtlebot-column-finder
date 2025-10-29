color = inf;
group = inf;
shape = inf;

bbmovedeg(rob, [0 0 0 0 0 0]);
bbwaitforready(rob);

imag = flygrab();

matrix = coordinates_transformation;
last_deg = [0 0 0 0 0 0];

[image , maskedRGB] = createMask(imag);
image = conv_hull(image);

[props,num] = shape_finder(image);
props = find_size(props,num);

[red,red_stats] = createRed3Mask(imag);
[purple, purple_stats] = createPurple3Mask(imag);
[yellow, yellow_stats] = createYellow4Mask(imag);
[green, green_stats] = createGreen4Mask(imag);
[dark_blue, dark_blue_stats] = createDarkBlueMask(imag);
[light_blue, light_blue_stats] = createLightBlueMask(imag);
[golden, golden_stats] = createGoldenMask(imag);

colors = {red,purple,yellow,green,dark_blue,light_blue, golden};
stats = {red_stats, purple_stats,yellow_stats,green_stats,dark_blue_stats,light_blue_stats,golden_stats};

[props(:).Color] = deal(0);

for i = 1:length(stats)
    if length(stats{1,i}) > 1
        for j = 1:length(props)
            statistics = stats{1,i};
            for k = 1:length(statistics)
                if sum(and(round(props(j).Centroid(1)) == statistics(k).PixelList(:,1), round(props(j).Centroid(2)) == statistics(k).PixelList(:,2))) == 1
                    props(j).Color = num2str(i);
                end
            end
        end
    end
end

[props, num_groups] = find_group(props);
props = find_angle(props);

for j = 1:length(props)
    if props(j).Shape=='circle'
        props(j).NewFeretAngle = 0;
    end
    if props(j).NewFeretAngle < 100 && props(j).NewFeretAngle > 80
        props(j).NewFeretAngle = 0;
    end
end

gripper = 1;
height = NaN;
height_goal = 180;
pack_size = inf;
goal_size = inf;
con = 1;

for i = 1:num_groups
    ang = 0;
    unreachable = 0;
    groupI = ([props.Group] == i);

    for j = 1:length(groupI)
        if groupI(j) == 1 && props(j).Color == 0
            con = 0;
        end
    end

    group_no = sum(groupI);
    height_check = 100;

    for j = 1:length(groupI)
        if groupI(j)==1 && con==1 && group_no>1
            vektor = [props(j).Centroid 1]';
            rob_coord = matrix*vektor;

            if group_no == 2
                if props(j).Size=='L', height_check = 140; end
                if props(j).Size=='M', height_check = 50; end
                if props(j).Size=='S', height_check = 30; end
            end

            if group_no == 3
                if props(j).Size=='L', height_check = 180; end
                if props(j).Size=='M', height_check = 50; end
                if props(j).Size=='S', height_check = 30; end
            end

            a = rob_coord(1:2,:)';
            next_pos = [a height_check 0 90 0];
            sol = best_ikt(next_pos, last_deg, rob);
            if isnan(sol)
                groupI(j)=0;
            end
        end
    end

    if sum(groupI) == 2 && con == 1
        for j=1:length(groupI)
            if groupI(j)==1
                if props(j).Size == 'M'
                    goal_coord = props(j).Centroid;
                    goal_size = 'M';
                    height_goal = 100;
                end
                if props(j).Size == 'S'
                    pack_coord = props(j).Centroid;
                    ang = props(j).NewFeretAngle;
                    height = 30;
                    gripper = 1;
                end
            end
        end

        for j=1:length(groupI)
            if groupI(j)==1
                if props(j).Size == 'L'
                    goal_coord = props(j).Centroid;
                    goal_size = 'L';
                    height_goal = 110;
                end
            end
        end

        for j=1:length(groupI)
            if groupI(j)==1
                if props(j).Size == 'M' && goal_size~='M'
                    pack_coord = props(j).Centroid;
                    ang = props(j).NewFeretAngle;
                    height_goal = 140;
                    height = 60;
                end
            end
        end

        movement_package(pack_coord,height,rob,ang);
        move_goal(goal_coord, height_goal,rob,pack_coord);
        bbmovedeg(rob, [0 0 0 0 0 0]);
        bbwaitforready(rob);
    end

    if sum(groupI)==3 && con==1
        height = 40;
        height_goal = 180;

        for j=1:length(groupI)
            if groupI(j)==1 && props(j).Size=='M'
                pack_coord = props(j).Centroid;
                ang = props(j).NewFeretAngle;
                height = 50;
            end
            if groupI(j)==1 && props(j).Size=='L'
                goal_coord = props(j).Centroid;
                height_goal = 135;
            end
        end

        movement_package(pack_coord,height,rob,ang);
        move_goal(goal_coord, height_goal,rob,pack_coord);

        for j=1:length(groupI)
            if groupI(j)==1 && props(j).Size=='S'
                pack_coord = props(j).Centroid;
                ang = props(j).NewFeretAngle;
                height = 30;
                height_goal = 170;
            end
        end

        movement_package(pack_coord,height,rob,ang);
        move_goal(goal_coord, height_goal,rob,pack_coord);
        bbmovedeg(rob, [0 0 0 0 0 0]);
    end

    goal_size = inf;
    con = 1;
end

centroids = cat(1,props(:).Centroid);
imshow(imag)
hold on

for i=1:length(props)
    t(i)= text(centroids(i,1),centroids(i,2),num2str(props(i).Group));
    t(i).Color = 'red';
    t(i).FontSize = 14;
end

hold off
