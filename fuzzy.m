        % Create a fuzzy inference system
        fis = mamfis('Name', 'environment');
        
        % Add input variables
        fis = addInput(fis, [0 100],'Name', 'temperature');
        fis = addInput(fis,[0 100], 'Name', 'lightning');
        fis = addInput(fis,[0 100], 'Name', 'motion');
        fis = addInput(fis,[0 100], 'Name', 'humidity');
        
        
        
        % Add output variables
        fis = addOutput(fis,[0 100],'Name', 'heater_power');
        fis = addOutput(fis,[0 100],'Name', 'blinds_position');
        
        % Set the parameters for trimf membership functions
        fis = addMF(fis, 'temperature', 'trimf', [0 0 20], 'Name', 'cold');
        fis = addMF(fis, 'temperature', 'trimf', [15 25 35], 'Name', 'comfortable');
        fis = addMF(fis, 'temperature', 'trimf', [30 40 40], 'Name', 'hot');
        
        fis = addMF(fis, 'lightning', 'trimf', [0 0 40], 'Name', 'low');
        fis = addMF(fis, 'lightning', 'trimf', [20 50 80], 'Name', 'medium');
        fis = addMF(fis, 'lightning', 'trimf', [60 100 100], 'Name', 'high');
        
        fis = addMF(fis, 'motion', 'trimf', [0 0 30], 'Name', 'yes');
        fis = addMF(fis, 'motion', 'trimf', [20 50 80], 'Name', 'no');
        
        
        fis = addMF(fis, 'humidity', 'trimf', [0 0 30], 'Name', 'dry');
        fis = addMF(fis, 'humidity', 'trimf', [20 50 80], 'Name', 'normal');
        fis = addMF(fis, 'humidity', 'trimf', [70 100 100], 'Name', 'moist');
        
        fis = addMF(fis, 'heater_power', 'trimf', [0 0 30], 'Name', 'low');
        fis = addMF(fis, 'heater_power', 'trimf', [20 50 80], 'Name', 'medium');
        fis = addMF(fis, 'heater_power', 'trimf', [60 100 100], 'Name', 'high');
        
        fis = addMF(fis, 'blinds_position', 'trimf', [0 0 30], 'Name', 'closed');
        fis = addMF(fis, 'blinds_position', 'trimf', [20 50 80], 'Name', 'partially_open');
        fis = addMF(fis, 'blinds_position', 'trimf', [60 100 100], 'Name', 'open');
        
        % Add rules
        fis = addRule(fis, 'temperature==cold & humidity==moist => heater_power==high');
        fis = addRule(fis, 'temperature==hot & humidity==dry=> heater_power==low');
        fis = addRule(fis, 'motion==yes => heater_power==low');
        fis = addRule(fis, 'motion==yes => blinds_position==open');
        fis = addRule(fis, 'motion==no => heater_power==medium');
        
        
        % Set inputs (replace these values with actual sensor readings)output
        inputValues = [10,90,80,10]
        % Evaluate the fuzzy inference system
        outputValues = evalfis(fis, inputValues);
        disp(outputValues);
        
        % Display results
        disp(['Heater Power: ', num2str(outputValues(1))]);
        disp(['Blinds Position: ', num2str(outputValues(2))]);
        
        % Display triggered rules based on output membership values
        [~, heaterPowerRuleIndex] = max(outputValues(1));
        [~, blindsPositionRuleIndex] = max(outputValues(2));
        
        disp(['Triggered Heater Power Rule: ', num2str(heaterPowerRuleIndex)]);
        disp(['Triggered Blinds Position Rule: ', num2str(blindsPositionRuleIndex)]);
        
        % Plot input membership functions
        figure;
        subplot(4, 1, 1);
        plotmf(fis, 'input', 1);
        title('Membership Functions for Temperature');
        set(gca, 'XTick', [0 20 25]); % Adjust the x-axis ticks for better visibility
        
        
        subplot(4, 1, 2);
        plotmf(fis, 'input', 2);
        title('Membership Functions for Lightning');
        set(gca, 'XTick', [0 50 100]); % Adjust the x-axis ticks for better visibility
        
        
        subplot(4, 1, 3);
        plotmf(fis, 'input', 3);
        title('Membership Functions for Motion');
        set(gca, 'XTick', [0 50 100]); % Adjust the x-axis ticks for better visibility
        
        subplot(4, 1, 4);
        plotmf(fis, 'input', 4);
        title('Membership Functions for Humidity');
        set(gca, 'XTick', [0 50 100]); % Adjust the x-axis ticks for better visibility
        
        
        
        
        % Set the renderer property to 'painters'
        set(gcf, 'Renderer', 'painters');
        % Pause and wait for user interaction
        uiwait(gcf);
        
        % Plot output membership functions
        figure;
        subplot(2, 1, 1);
        plotmf(fis, 'output', 1);
        title('Output Membership Functions for Heater Power');
        
        subplot(2, 1, 2);
        plotmf(fis, 'output', 2);
        title('Output Membership Functions for Blinds Position');
        
        % Set the renderer property to 'painters'
        set(gcf, 'Renderer', 'painters');
        
        % Pause to keep figures open
        uiwait(gcf);% Create a fuzzy inference system
        
        figure;
        plotfis(fis);
        title('Defuzzification Process');
        
        % Set the renderer property to 'painters'
        set(gcf, 'Renderer', 'painters');
        
        % Pause to keep figures open
        uiwait(gcf);% Create a fuzzy inference system
        
        
        showrule(fis)
        
        % % Use ruleview to visualize the rule surface
         ruleview(fis);

         
         % PART 2
% Extract membership values from the fired rules for the second output variable
membershipValues = outputValues(2);

if isempty(membershipValues)
    error('Unexpected output structure from evalfis.');
end

objectiveFunction = @(inputValues) -membershipValues(1);


% Genetic algorithm options
options = optimoptions('ga', 'PopulationSize', 50, 'MaxGenerations', 100);

% Constraints on input values (if any)
lb = [0, 0, 0, 0];  % Lower bounds for temperature, lighting, motion, humidity
ub = [100, 100, 100, 100];  % Upper bounds for temperature, lighting, motion, humidity

% Run genetic algorithm
[inputOptimal, objectiveOptimal] = ga(objectiveFunction, 4, [], [], [], [], lb, ub, [], options);

% Display results
disp(['Optimal Input Values: ', num2str(inputOptimal)]);
disp(['Optimal Optimization Metric: ', num2str(-objectiveOptimal)]);

% Evaluate fuzzy inference system with optimal input values
outputOptimal = evalfis(fis, inputOptimal);
disp(['Optimal Heater Power: ', num2str(outputOptimal(1))]);
disp(['Optimal Blinds position: ', num2str(outputOptimal(2))]);



% PART 3 compare between particle swarn and pattern search algorith of
% CEC'2005 functions

% particleswarm
% Define the objective function to maximize speakerVolume
membershipValues = outputValues(2);
objectiveFunction = @(inputValues) -membershipValues;

% Particle Swarm Optimization options
options = optimoptions('particleswarm', 'SwarmSize', 50, 'MaxIterations', 100);

% Constraints on input values (if any)
lb = [0, 0, 0, 0];  % Lower bounds for temperature, lighting, motion, humidity
ub = [100, 100, 100, 100];  % Upper bounds for temperature, lighting, motion, humidity

% Run Particle Swarm Optimization
[inputOptimal, objectiveOptimal] = particleswarm(objectiveFunction, 4, lb, ub, options);

% Display results
disp(['Optimal Input Values: ', num2str(inputOptimal)]);
disp(['Optimal Optimization Metric: ', num2str(-objectiveOptimal)]);

% Evaluate fuzzy inference system with optimal input values
outputOptimal = evalfis(fis, inputOptimal);
disp(['Optimal Heater Power: ', num2str(outputOptimal(1))]);
disp(['Optimal Blinds position: ', num2str(outputOptimal(2))]);


% pattern search
% Define the objective function to maximize speakerVolume
membershipValues = outputValues(2);

objectiveFunction = @(inputValues) -membershipValues;

% Pattern Search options
options = optimoptions('patternsearch', 'InitialMeshSize', 10, 'MaxIterations', 100);

% Constraints on input values (if any)
lb = [0, 0, 0, 0];  % Lower bounds for temperature, lighting, motion, humidity
ub = [100, 100, 100, 100];  % Upper bounds for temperature, lighting, motion, humidity

% Run pattern search
inputOptimal = patternsearch(objectiveFunction, zeros(4,1), [], [], [], [], lb, ub, [], options);
objectiveOptimal = -objectiveFunction(inputOptimal);

% Display results
disp(['Optimal Input Values: ', num2str(inputOptimal', '%.2f, ')]);
disp(['Optimal Optimization Metric: ', num2str(objectiveOptimal)]);

% Evaluate fuzzy inference system with optimal input values
outputOptimal = evalfis(fis, inputOptimal);
disp(['Optimal Heater Power: ', num2str(outputOptimal(1))]);
disp(['Optimal Blinds position: ', num2str(outputOptimal(2))]);



        
        