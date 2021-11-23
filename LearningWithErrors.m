%% Config
fileID = fopen("measure.txt"); % Open file
data = fread(fileID, 'ubit1'); % Interpret file as bit array
fclose(fileID);

config = 1; % Which spec configuration
N = size(data, 1); % Message length

% Generate list of primes
p_num = primes(65535);

% Find values for each config
p_startindex = 1;
p_endindex = 1;
e_mag = 0;
rows = 1;
cols = 1;

if config == 1
    p_startindex = 1;
    p_endindex = 31;
    e_mag = 1;
    rows = 256;
    cols = 4;
elseif config == 2
    p_startindex = 310;
    p_endindex = 1028;
    e_mag = 4;
    rows = 8192;
    cols = 8;
elseif config == 3
    p_startindex = 1891;
    p_endindex = 6542;
    e_mag = 16;
    rows = 32768;
    cols = 16;
end

sigma = e_mag/3;

% Determine index of q
p_index = randi([p_startindex p_endindex]);

%% Setup
% Get value of q
q = p_num(p_index);

% Random message
M = randi([0 1], 1, N);

% Random secret
s = randi([0 q], cols, 1);

% Random A matrix
A = randi([0 q], rows, cols);

%% Exact B generation
B_exact = keygen_exact(A, s, q, e_mag);

%% Approx
B_approx = keygen_approx(A, s, q);

%% Encryption and Decryption
M_decexact = zeros(N, 1);
M_decapprox = zeros(N, 1);

errors_exact = 0;
errors_approx = 0;

for i = 1:N
    % Encrypt
    [u_exact, v_exact] = encrypt(M(i), A, B_exact, q);
    [u_approx, v_approx] = encrypt(M(i), A, B_approx, q);
    
    % Decrypt
    M_decexact(i) = decrypt(u_exact, v_exact, s, q);
    M_decapprox(i) = decrypt(u_approx, v_approx, s, q);
    
    if M(i) ~= M_decexact(i)
        errors_exact = errors_exact + 1;
    end
    if M(i) ~= M_decapprox(i)
        errors_approx = errors_approx + 1;
    end
    
    
end

%% Print to file
fileID = fopen("exact_message.txt", 'w');
fwrite(fileID, data, 'ubit1');
fclose(fileID);

fileID = fopen("approx_message.txt", 'w');
fwrite(fileID, data, 'ubit1');
fclose(fileID);

%% Evaluate Effectiveness
exact_failure_perc = errors_exact/N *100;
approx_failure_perc = errors_approx/N *100;

%% Functions
% Exact B
function B_exact = keygen_exact(A, s, q, sigma)
    e = round(normrnd(0, sigma, size(A, 1), 1));
    B_exact = mod((A * s + e), q);
end

% Approximate B
function B_approx = keygen_approx(A, s, q)
    % Initialise B vector
    B_approx = zeros(size(A, 1), 1);
    
    % Compute approx A * s
    % For each row of A
    for i = 1:size(A, 1)
       sum = 0;
       for j = 1:size(A, 2)
          sum = sum + fn_MitchellMul_MBM_t(A(i, j), s(j, 1), 8, 8);
       end
       B_approx(i, 1) = mod(sum, q);
    end
end

% Encryption algorithm
function [u, v] = encrypt(M, A, B, q)
    % Sample random rows e.g. 5th and 8th
    n_sam = rand([1 size(A, 1)]);
    u = zeros(1, size(A, 2));
    v = 0;
    
    % Get a get random number of random matrix indices
    for i = 1:n_sam
        for j = 1:i
           u = u + A(j, :);
           v = v + B(j, :);
        end
    end
    u = mod(u, q);
    v = mod(v - floor(q/2*M), q);
end

% Decryption algorithm
function M_dec = decrypt(u, v, s, q)
    dec = mod(abs(v - u * s), q);
    M_dec = dec > q/4 & dec < 3*q/4;
end