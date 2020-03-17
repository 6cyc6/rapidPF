function bool = verify_power_flow_equations(mpc)
% verify_power_flow_equations
%
%   `copy the declaration of the function in here (leave the ticks unchanged)`
%
%   _describe what the function does in the following line_
%
%   # Markdown formatting is supported
%   Equations are possible to, e.g $a^2 + b^2 = c^2$.
%   So are lists:
%   - item 1
%   - item 2
%   ```matlab
%   function y = square(x)
%       x^2
%   end
%   ```
%   See also: [run_case_file_splitter](run_case_file_splitter.md)
    mpc = ext2int(mpc);
    Y = makeYbus(mpc);
    bool = verify_function(mpc, @(ang, mag, p, q)create_power_flow_equations(ang, mag, p, q, Y), 'power flow equations');
end

