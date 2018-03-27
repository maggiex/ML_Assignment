function signew = generate_sig(sig)
signew = sig;
swap1 = randi(length(sig));
swap2 = randi(length(sig));
if swap1==swap2
    signew = generate_sig(sig);
else
    signew([swap1,swap2]) = signew([swap2,swap1]);
end
end