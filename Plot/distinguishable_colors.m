function colors = distinguishable_colors(n_colors, bg, func)
  % Initial setup for generating colors in Lab space
  if nargin < 2
    bg = [1 1 1]; % Default white background
  else
    bg = parseInputColor(bg);
  end
  
  % Generate colors in Lab space
  n_grid = 30;
  [R,G,B] = ndgrid(linspace(0,1,n_grid));
  rgb = [R(:) G(:) B(:)];
  if nargin < 3
    C = makecform('srgb2lab');
    lab = applycform(rgb,C);
    bglab = applycform(bg,C);
  else
    lab = func(rgb);
    bglab = func(bg);
  end
  
  % Select distinguishable colors
  colors = selectDistinguishableColors(n_colors, lab, bglab);
  
  % Soften and adjust RGB components
  colors = adjustAndSoftenColors(colors);
end

function bg = parseInputColor(bg)
  if iscell(bg)
    bgc = cellfun(@colorstr2rgb, bg, 'UniformOutput', false);
    bg = cat(1,bgc{:});
  else
    bg = colorstr2rgb(bg);
  end
end

function colors = selectDistinguishableColors(n_colors, lab, bglab)
  mindist2 = inf(size(lab,1),1);
  colors = zeros(n_colors,3);
  lastlab = bglab(end,:);
  for i = 1:n_colors
    dX = bsxfun(@minus,lab,lastlab);
    dist2 = sum(dX.^2,2);
    mindist2 = min(dist2,mindist2);
    [~,index] = max(mindist2);
    lastlab = lab(index,:);
    colors(i,:) = applycform(lab(index,:), makecform('lab2srgb'));
  end
end

function colors = adjustAndSoftenColors(colors)
  for i = 1:size(colors,1)
    % Soften the color (example: increase lightness, decrease saturation)
    colors(i,:) = colors(i,:) + (1 - colors(i,:)) * 0.4; % Making colors lighter
    
    % Apply specific adjustments to RGB components
    % Example adjustments: Increase red and green, adjust blue/yellow balance
    colors(i,1) = min(colors(i,1) * 0.9, 1); % Increase red
    colors(i,2) = min(colors(i,2) * 1, 1); % Increase green
    % Adjust blue to affect yellow (since yellow in RGB is a mix of red and green)
    colors(i,3) = min(colors(i,3) * 1, 1); % Adjust blue
  end
end

function c = colorstr2rgb(c)
  % Converts color specification strings to RGB values
  ...
end
