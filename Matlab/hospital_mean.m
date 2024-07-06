%hospital_mean.m

function [men_mean,women_mean, men_data_hn_30_50,men_data_hn_u30, men_data_hn_o50, women_data_hn_30_50, women_data_hn_u30,...
    women_data_hn_o50] = hospital_mean(patients,files_patients,folder_path, ...
    men_mean,women_mean, men_data_hn_30_50,men_data_hn_u30, men_data_hn_o50, women_data_hn_30_50,...
    women_data_hn_u30, women_data_hn_o50, hospital_id)


hmr_patient_id_mapping = containers.Map(...
    {'hmr_001_landmark', 'hmr_002_landmark', 'hmr_003_landmark', 'hmr_004_landmark', ...
     'hmr_005_landmark', 'hmr_006_landmark', 'hmr_007_landmark', 'hmr_008_landmark', ...
     'hmr_019_landmark', 'hmr_027_landmark', 'landmark_distances_hn_hrm_041'}, ...
    {'HN-HMR-001', 'HN-HMR-002', 'HN-HMR-003', 'HN-HMR-004', ...
     'HN-HMR-005', 'HN-HMR-006', 'HN-HMR-007', 'HN-HMR-008', ...
     'HN-HMR-019', 'HN-HMR-027','HN-HMR-041'});

chum_patient_id_mapping = containers.Map(...
    {'landmark_distances_mm_1', 'landmark_distances_mm_3', 'landmark_distances_mm_4', ...
    'landmark_distances_mm_5','landmark_distances_mm_6','landmark_distances_mm_7' ...
    'landmark_distances_mm_8','landmark_distances_mm_11','landmark_distances_mm_13','landmark_distances_mm_14', ...
    'landmark_distances_hn_chum_061','landmark_distances_hm_chum_063', 'landmark_distances_hn_chum_064'}, ...
    {'HN-CHUM-001', 'HN-CHUM-003', 'HN-CHUM-004',... 
     'HN-CHUM-005', 'HN-CHUM-006','HN-CHUM-007','HN-CHUM-008','HN-CHUM-011', ...
     'HN-CHUM-013','HN-CHUM-014','HN-CHUM-061', ...
     'HN-CHUM-063', 'HN-CHUM-064'} );

hgj_patient_id_mapping = containers.Map(...
    {'HN-HGJ-005', 'HN-HGJ-006', 'HN-HGJ-008', ...
    'HN-HGJ-009','HN-HGJ-012','landmark_distances_hn_hgj_091'}, ...
    {'HN-HGJ-005', 'HN-HGJ-006', 'HN-HGJ-008',... 
     'HN-HGJ-009', 'HN-HGJ-012', 'HN-HGJ-091' } );

% Read CSV file
    for i = 1:length(files_patients)
                file_path = fullfile(folder_path, files_patients(i).name);
                patient_landmark = readtable(file_path);
                name_id = strsplit(files_patients(i).name, '.');
                name_id = name_id{1};

                if (hospital_id == 1) 
                      patient_id = chum_patient_id_mapping(name_id);

                      index_column = i;
                      
                end
                if (hospital_id == 2)
                    patient_id = hmr_patient_id_mapping(name_id);
                    index_column = i+length(chum_patient_id_mapping);

                end
                % if(hospital_id ==4 )
                %      patient_id = chus_patient_id_mapping(name_id);
                %      index_column = i+30;
                % end
                if (hospital_id == 3) %id4
                      patient_id = hgj_patient_id_mapping(name_id);
                      index_column = i+length(chum_patient_id_mapping)+ length(hmr_patient_id_mapping);
                end
                patient = patients(strcmp(patients{:, 'Patient #'}, patient_id), :);
                
                % Determine age category
                if (patient.Age < 30)
                    age = 'Under 30';
                    index = 1;
                elseif (patient.Age >= 30 && patient.Age < 50)
                    age = '30-50';
                    index = 11;
                elseif (patient.Age >= 50)
                    age = 'Over 50';
                    index = 21;
                end
            
                % Update mean and standard deviation for men
                if (strcmp(patient.Sex, 'M'))
                    if(strcmp(age, '30-50'))
                         men_data_hn_30_50(:, index_column) = patient_landmark.Distance_mm;
                    end
                    if (strcmp(age,'Under 30'))
                        
                        men_data_hn_u30(:, index_column) = patient_landmark.Distance_mm;
                    end
                    if (strcmp(age,'Over 50'))
                        
                        men_data_hn_o50(:, index_column) = patient_landmark.Distance_mm;
                    end
                    men_mean.("Num Patients")(index:index+9) = men_mean.("Num Patients")(index:index+9) + 1;
            
                end
            
                % Update mean and standard deviation for women
                if (strcmp(patient.Sex, 'F'))
            
                    if(strcmp(age, '30-50'))
                        women_data_hn_30_50(:, index_column) = patient_landmark.Distance_mm;
                    end
                    if (strcmp(age,'Under 30'))
                        women_data_hn_u30(:, index_column) = patient_landmark.Distance_mm;
                    end
                    if (strcmp(age,'Over 50'))
                        women_data_hn_o50(:, index_column) = patient_landmark.Distance_mm;
                    end
            
                    women_mean.("Num Patients")(index:index+9) = women_mean.("Num Patients")(index:index+9) + 1;
                end
    end
end
