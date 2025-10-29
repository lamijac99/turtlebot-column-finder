function [props, group] = find_group(props)
% Assigns each object in props to a group based on Color and Shape

group = 1;
[props(:).Group] = deal(0);

for i = 1:length(props)
    if props(i).Group == 0
        props(i).Group = group;
        
        for j = 1:length(props)
            if props(i).Color == props(j).Color && sum(props(i).Shape == props(j).Shape) == 6
                props(j).Group = group;
            end
        end
        
        group = group + 1;
    end
end

group = group - 1;

end
