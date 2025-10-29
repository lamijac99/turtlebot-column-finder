function best = best_ikt(pos, last_deg, rob)

deg = bbiktred(rob, pos);

if isempty(deg)
    best = NaN;
    return
end

for i = 1:size(deg,1)
    normy(i) = norm(last_deg - deg(i,:));
end

[~, I] = min(normy);
best = deg(I,:);
