% For any question you can conntact Omri Matania by email: omrimatania@gmail.com  

clear all; close all;

% ----------------------------------------------------------------------- %
% Datasets loading
% ----------------------------------------------------------------------- %
tic()

num_harmonies = 10 ;
num_of_first_indices_2_set_2_zero = 10 ; % for zeroing DC values that harm the normalization process.
data_path = 'E:\data\papers\zero_fault_shot_learning\datasets\' ;

load([data_path, 'endurence_database.mat'])

dataset_name = 'NBSWT' ; % CWRU, PU, XJTU_SY, PRONOSTIA_FEMTO, NBSWT_dataset
part = 1 ;
load([data_path,dataset_name,'_dataset.mat'])

if strcmp('MFPT', dataset_name)
    test_dataset = MFPT_dataset ;
elseif strcmp('CWRU', dataset_name)
    test_dataset = CWRU_dataset ;
    if part == 1 
        inds = find(abs(test_dataset.d_order - 0.0033) < 0.00005) ;
    elseif part == 2 
        inds = find(abs(test_dataset.d_order - 0.0034) < 0.00005) ;
    elseif part == 3
        inds = find(abs(test_dataset.d_order - 0.0123) < 0.00005) ;
    elseif part == 4
        inds = find(abs(test_dataset.d_order - 0.0125) < 0.00005) ;
    elseif part == 5
        inds = find(abs(test_dataset.d_order - 0.0065) < 0.00005) ;
    elseif part == 6
        inds = find(abs(test_dataset.d_order - 0.0066) < 0.00005) ;
    elseif part == 7
        inds = find(abs(test_dataset.d_order - 0.0043) < 0.00005) ;
    elseif part == 8
        inds = find(abs(test_dataset.d_order - 0.0129) < 0.00005) ;
    end
    test_dataset.d_order = test_dataset.d_order(inds) ;
    test_dataset.signals = test_dataset.signals(inds) ;
    test_dataset.spall_orders = test_dataset.spall_orders(:, inds) ;
    test_dataset.spall_types = test_dataset.spall_types(inds) ;
elseif strcmp('PU', dataset_name)
    test_dataset = PU_dataset ;
    if part == 1 
        inds = find(abs(test_dataset.d_order - 0.0167) < 0.00005) ;
    elseif part == 2 
        inds = find(abs(test_dataset.d_order - 0.0100) < 0.00005) ;
    end
    test_dataset.d_order = test_dataset.d_order(inds) ;
    test_dataset.signals = test_dataset.signals(inds) ;
    test_dataset.spall_orders = test_dataset.spall_orders(:, inds) ;
    test_dataset.spall_types = test_dataset.spall_types(inds) ;
elseif strcmp('XJTU_SY', dataset_name)
    test_dataset = XJTU_SY_dataset ;
    if part == 1 
        inds = find(abs(test_dataset.d_order - 0.0223) < 0.00005) ;
    elseif part == 2 
        inds = find(abs(test_dataset.d_order - 0.0208) < 0.00005) ;
    elseif part == 3 
        inds = find(abs(test_dataset.d_order - 0.0195) < 0.00005) ;
    end
    test_dataset.d_order = test_dataset.d_order(inds) ;
    test_dataset.signals = test_dataset.signals(inds) ;
    test_dataset.spall_orders = test_dataset.spall_orders(:, inds) ;
    test_dataset.spall_types = test_dataset.spall_types(inds) ;
elseif strcmp('PRONOSTIA_FEMTO', dataset_name)
    test_dataset = PRONOSTIA_FEMTO_dataset ;
    if part == 1 
        inds = find(abs(test_dataset.d_order - 0.3636) < 0.00005) ;
    elseif part == 2 
        inds = find(abs(test_dataset.d_order - 0.4000) < 0.00005) ;
    end
    test_dataset.d_order = test_dataset.d_order(inds) ;
    test_dataset.signals = test_dataset.signals(inds) ;
    test_dataset.spall_orders = test_dataset.spall_orders(:, inds) ;
    test_dataset.spall_types = test_dataset.spall_types(inds) ;
elseif strcmp('NBSWT', dataset_name)
    test_dataset = NBSWT_dataset ;
end

test_dataset.spall_orders = test_dataset.spall_orders(:, 1) ;
test_dataset.d_order = test_dataset.d_order(1) ;

% load([data_path, 'CWRU_dataset.mat'])
% load([data_path, 'MFPT_dataset.mat'])
% load([data_path, 'PU_dataset.mat'])
% load([data_path, 'XJTU_SY_dataset.mat'])
% load([data_path, 'PRONOSTIA_FEMTO_dataset.mat'])
% load([data_path, 'NBSWT_dataset.mat'])

% ----------------------------------------------------------------------- %
% Generation of the simulated and endurence datasets
% ----------------------------------------------------------------------- %
spall_orders = test_dataset.spall_orders ;
new_d_order = test_dataset.d_order ;

num_of_sigs_per_category = size(endurence_database.signals, 2) ;
[X_sim, y_sim] = generate_and_process_simulated_dataset_4_CNN(data_path, spall_orders, ...
    num_of_sigs_per_category, new_d_order, num_harmonies, num_of_first_indices_2_set_2_zero) ;

[X_endurence, y_endurence] = augment_and_process_endurence_dataset_4_CNN(endurence_database, ...
    spall_orders, new_d_order, num_harmonies, num_of_first_indices_2_set_2_zero) ;
% 
% X_training = [X_sim, X_endurence] ;
% y_training = [y_sim, y_endurence] ;
X_training = [X_sim] ;
y_training = [y_sim] ;

% ----------------------------------------------------------------------- %
% Processing the vlidation and test datasets
% ----------------------------------------------------------------------- %

[X_test, y_test] = physical_doamin_adaptation_4_CNN(test_dataset, num_harmonies, ...
    num_of_first_indices_2_set_2_zero) ;

% ----------------------------------------------------------------------- %
% Data saving
% ----------------------------------------------------------------------- %

if strcmp('PRONOSTIA_FEMTO', dataset_name)
    X_training = [X_training; zeros(2000, size(X_training, 2))] ;
    X_test = [X_test; zeros(2000, size(X_test, 2))] ;
end

save([data_path, 'processed_data.mat'], 'X_training', 'y_training', ...
    'X_test', 'y_test')

