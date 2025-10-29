function props = find_angle(props)

for i = 1:length(props)
    angle = (props(i).MaxFeretAngle(:) - 45);
    
    if angle < -180
        angle = angle + 180;
    end
    if angle > 180
        angle = angle - 180;
    end
    
    props(i).NewFeretAngle(:) = angle;
end

end
