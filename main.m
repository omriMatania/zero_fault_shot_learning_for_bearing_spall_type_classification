% For any question you can conntact Omri Matania by email: omrimatania@gmail.com  

clear all; close all;

use_transform_spall_sigs = 1 ;
num_harmonies = 10 ;
order_tolerance = 0.02 ;

% ----------------------------------------------------------------------- %
% Datasets loading
% ----------------------------------------------------------------------- %
tic()

data_path = 'D:\data\papers\zero_fault_shot_learning\datasets\' ;

load([data_path, 'endurence_database.mat'])
load([data_path, 'CWRU_dataset.mat'])
load([data_path, 'MFPT_dataset.mat'])
load([data_path, 'PU_dataset.mat'])
load([data_path, 'XJTU_SY_dataset.mat'])
load([data_path, 'PRONOSTIA_FEMTO_dataset.mat'])
load([data_path, 'NBSWT_dataset.mat'])

% ----------------------------------------------------------------------- %
% Generation of the simulated and endurence datasets
% ----------------------------------------------------------------------- %
num_of_sigs_per_category = size(endurence_database.signals, 2) ;
sim_spall_orders = [3.5, 5.2, 2.2] ;
[X_sim, y_sim] = generate_and_process_simulated_dataset(data_path, sim_spall_orders, num_harmonies, ...
    order_tolerance, num_of_sigs_per_category) ;

[X_endurence, y_endurence] = augment_and_process_endurence_dataset(endurence_database, ...
    num_harmonies, order_tolerance) ;
if ~use_transform_spall_sigs
    inds = find(y_endurence == 3) ; 
    X_endurence = X_endurence(:, inds) ;
    y_endurence = y_endurence(inds) ;
end

% X_endurence_without_augment = X_endurence(:, find(y_endurence==1)) ;
% y_endurence_without_augment = y_endurence(find(y_endurence==1)) ;
% X_training = [X_sim, X_endurence_without_augment] ;
% y_training = [y_sim, y_endurence_without_augment] ;
% X_training = [X_sim] ;
% y_training = [y_sim] ;
X_training = [X_sim, X_endurence] ;
y_training = [y_sim, y_endurence] ;

% ----------------------------------------------------------------------- %
% Processing the vlidation and test datasets
% ----------------------------------------------------------------------- %

disp('Domain adaptation of CWRU dataset')
[X_CWRU, y_CWRU] = physical_doamin_adaptation(CWRU_dataset, num_harmonies, ...
    order_tolerance) ;
disp('Domain adaptation of MFPT dataset')
[X_MFPT, y_MFPT] = physical_doamin_adaptation(MFPT_dataset, num_harmonies, ...
    order_tolerance) ;
disp('Domain adaptation of PU dataset')
[X_PU, y_PU] = physical_doamin_adaptation(PU_dataset, num_harmonies, ...
    order_tolerance) ;
disp('Domain adaptation of XJTU_SY dataset')
[X_XJTU_SY, y_XJTU_SY] = physical_doamin_adaptation(XJTU_SY_dataset, num_harmonies, ...
    order_tolerance) ;
disp('Domain adaptation of PRONOSTIA-FEMTO dataset')
[X_PRONOSTIA_FEMTO, y_PRONOSTIA_FEMTO] = physical_doamin_adaptation(PRONOSTIA_FEMTO_dataset, ...
    num_harmonies, order_tolerance) ;
disp('Domain adaptation of NBSWT dataset')
[X_NBSWT, y_NBSWT] = physical_doamin_adaptation(NBSWT_dataset, ...
    num_harmonies, order_tolerance) ;

% ----------------------------------------------------------------------- %
% Data saving
% ----------------------------------------------------------------------- %

save([data_path, 'processed_data.mat'], 'X_training', 'y_training', 'X_CWRU', ...
    'y_CWRU', 'X_MFPT', 'y_MFPT', 'X_PU', 'y_PU', 'X_XJTU_SY', 'y_XJTU_SY', ...
    'X_PRONOSTIA_FEMTO', 'y_PRONOSTIA_FEMTO', 'X_NBSWT', 'y_NBSWT')

