%%%% please give here you envelope time t_q and values Q_up_dowen
t_q = F2_AmpStep.t1;
Q_down_up = F2_AmpStep.Q_down_up; % please note sorting order of Q_up and Q_down

%%%% Unify the start time and end time
%%% e.g The simulation time doesn't begin from 0. 
%%%% e.g The envelope time ends before or after the simulation time.
t_begin = max(t(1), t_q(1));
t_end  = min(t(end), t_q(end)+t_begin);
figure(2)
plot(t_q+t_begin,Q_down_up,'r')
hold on
plot(t,q,'b');
legend(["Q_{down}" "Q_{up}" "Q"]);
xlim([t_begin,t_end]);
grid;

t1 = t;
q_sim = q;
t2 = t_q+t_begin;
t3 = t2; 

% 1. Interpolate p_up_lim and p_down_lim onto t1 to resolve the issue of different steps
q_up_lim = interp1(t2, Q_down_up(:,2), t1, 'linear', 'extrap');
q_down_lim = interp1(t3, Q_down_up(:,1), t1, 'linear', 'extrap');

% 2. Simulation time range & Comparison

idx_time = (t1 >= t_begin) & (t1 <= t_end);
idx_violate = idx_time & (q_sim > q_up_lim | q_sim < q_down_lim);

% 3. Find the violation points（all violation points）
violate_idx = find(idx_violate);    
first_idx = find(idx_violate,1,'first');
[row, col]= find(idx_violate); 

% 4. Handle the results (give a message if no violation points are found)
if isempty(violate_idx)
    disp('No violations found in t = %d ', t_begin,' to t = %d.', t_end);
else   
    [n m]=size(col);
    for i = 1:m
        k = col(i);

    %%% save as table in Vio_q      
Vio_q(1,:) = {'time','q\_down\_lim','q\_sim','q\_up\_lim'};
Vio_q{i+1,1} = t1(k);
Vio_q{i+1,2} = q_down_lim(k);
Vio_q{i+1,3} = q_sim(k);
Vio_q{i+1,4} = q_up_lim(k);

        %%% save as matrix in Violation_q
        Violation_q(i,1) = t1(k)';
        Violation_q(i,2)= q_down_lim(k)';
        Violation_q(i,3)= q_sim(k)';
        Violation_q(i,4)= q_up_lim(k)';   

    end

%%%% just show the first three rows
 fprintf('Found violations, when: t= %d \n', t1(first_idx));
 disp('the violation values save as matrix in Violation_q, save as table in Vio_q');
 disp('the first three violations');
 fprintf('t = %.6f | Q_down = %.6f | Q_sim = %.6f | Q_up = %.6f\n', ...
             t1(first_idx), q_down_lim(first_idx),q_sim(first_idx), q_up_lim(first_idx));
  fprintf('t = %.6f | Q_down = %.6f | Q_sim = %.6f | Q_up = %.6f\n', ...
             t1(first_idx+1),q_down_lim(first_idx+1),q_sim(first_idx+1), q_up_lim(first_idx+1));
   fprintf('t = %.6f | Q_down = %.6f | Q_sim = %.6f | Q_up = %.6f\n', ...
             t1(first_idx+2), q_down_lim(first_idx+2),q_sim(first_idx+2), q_up_lim(first_idx+2));
end


