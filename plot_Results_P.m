function plot_Results_P(name, t,p,t_begin,t_p,P_up, P_down)


t_end  = min(t(end), t_p(end)+t_begin);
hold off
plot(t_p+t_begin,P_down,'r--','LineWidth',2)
hold on
plot(t_p+t_begin,P_up,'r-.','LineWidth',2)
plot(t,p,'b');
legend(["P_{down}" "P_{up}" "P"]);
xlim([t_begin-.5,t_end]);
grid;


t1 = t;
p_sim = p;
t2 = t_p+t_begin;
t3 = t2; 

% 1. Interpolate p_up_lim and p_down_lim onto t1 to resolve the issue of different steps
p_up_lim = interp1(t2, P_up, t1, 'linear', 'extrap');
p_down_lim = interp1(t3, P_down, t1, 'linear', 'extrap');

% 2. Simulation time range & Comparison

idx_time = (t1 >= t_begin) & (t1 <= t_end);
idx_violate = idx_time & (p_sim > p_up_lim | p_sim < p_down_lim);

% 3. Find the violation points（all violation points）
violate_idx = find(idx_violate);    
first_idx = find(idx_violate,1,'first');
[row, col]= find(idx_violate); 

% 4. Handle the results (give a message if no violation points are found)
if isempty(violate_idx)
    disp(['No violations found in t = ', num2str(t_begin),' to t = ', num2str(t_end)]);
    title(['\bf Testcase ', name,': \color{green}successfull'])

else
    title(['\bf Testcase ', name,': \color{red}failed'])
    [n m]=size(col);
    for i = 1:m
        k = col(i);
    %%% saved as table in Vio_p      
Vio_p(1,:) = {'time','p\_down\_lim','p\_sim','p\_up\_lim'};
Vio_p{i+1,1} = t1(k);
Vio_p{i+1,2} = p_down_lim(k);
Vio_p{i+1,3} = p_sim(k);
Vio_p{i+1,4} = p_up_lim(k);

        %%% saved as matrix in Violation_p
        Violation_p(i,1) = t1(k)';
        Violation_p(i,2)= p_down_lim(k)';
        Violation_p(i,3)=p_sim(k)';
        Violation_p(i,4)= p_up_lim(k)';   

    end

%%%% just show the first three rows
 fprintf('Found violations, when: t= %d \n', t1(first_idx));
 disp('the violation values saved as matrix in Violation_p, save as table in Vio_p');
 disp('the first three violations');
 fprintf('t = %.6f | P_down = %.6f | P_sim = %.6f |P_up = %.6f\n', ...
             t1(first_idx), p_down_lim(first_idx),p_sim(first_idx), p_up_lim(first_idx));
  fprintf('t = %.6f | P_down = %.6f | P_sim = %.6f | P_up = %.6f\n', ...
             t1(first_idx+1),p_down_lim(first_idx+1),p_sim(first_idx+1), p_up_lim(first_idx+1));
   fprintf('t = %.6f | P_down = %.6f | P_sim = %.6f | P_up = %.6f\n', ...
             t1(first_idx+2), p_down_lim(first_idx+2),p_sim(first_idx+2), p_up_lim(first_idx+2));
 end