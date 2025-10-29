function props = find_size(props,num)
for i=1:num

    % if square
    if props(i).Shape == 'square'
        % uslov small 
        if props(i).Area> 1500 && props(i).Area< 7000
            props(i).Size = 'S';
        end
        % uslov medium
        if  props(i).Area>8000  && props(i).Area< 15000
            props(i).Size ='M';
        end
        % uslov large
        if  props(i).Area>17000 && props(i).Area< 30000 % provjeri za veliku kocku 
            props(i).Size = 'L';
        end
    end

    if props(i).Shape == 'circle'
        % uslov small
        if  props(i).Area>1500  && props(i).Area< 6000
            props(i).Size = 'S';
        end
        % uslov medium
        if  props(i).Area>7000 && props(i).Area<9800
            props(i).Size = 'M';
        end
        % uslov large
        if props(i).Area>10000 && props(i).Area<19000
            props(i).Size = 'L';
        end
    end

end

end
