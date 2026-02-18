%get current workspace variables
workspace_variables = who;

%use a function name which is most likely only defined in the RTB to 
%determine the absolut toolbox path
abspath_trplot = which('trplot');

if isempty(abspath_trplot)
    error("robotics toolbox is apparently not installed yet!");
end
%remove part related to particular function
rtb_core_path = erase(abspath_trplot, '\lib\spatial-math\trplot.m');

% Get all paths
allPaths = strsplit(path, pathsep);

% Initialize an empty cell array to store filtered paths
rtb_paths = {};

% Loop through each path
for i = 1:numel(allPaths)
    % Check if the current path contains RTB path
    if startsWith(allPaths{i}, rtb_core_path)
        % If it does, add it to the filtered paths cell array
        rtb_paths{end+1} = allPaths{i};
        % Remove the path from the original list
        allPaths{i} = '';
    end
end

% Remove empty elements (the filtered paths) from the original list
allPaths = allPaths(~cellfun('isempty', allPaths));

% Construct the new path string by adding the filtered paths at the beginning
newPath = [strjoin(rtb_paths, pathsep), pathsep, strjoin(allPaths, pathsep)];

% Set the new path
path(newPath);

% Find variables generated within the script (by determining delta between
% initial workspace variables and finale workspace variables)
script_variables = setdiff(who, workspace_variables);

% Clear variables generated within the script
clear(script_variables{:});
clear script_variables;