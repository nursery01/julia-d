run(`apt update`)
run(`apt install -y gcc g++ cmake ufw aria2 vim fail2ban p7zip p7zip-full p7zip-rar`)
io=open("/etc/environment","w")
# s="\n"
s1=raw"""export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/local/sbin"""
# s=string(s,s1)
write(io,s1)
close(io)
#run(`source /etc/environment`)
io=open("/etc/fail2ban/jail.conf","r")
s=readlines(io, keep=true)
for i=1:length(s)
    if occursin("bantime",s[i])&&!occursin("#",s[i])
        s[i]="bantime = 144000m\n"
    elseif occursin("findtime",s[i])&&!occursin("#",s[i])
        s[i]="findtime = 1440m\n"
    elseif occursin("maxretry",s[i])&&!occursin("#",s[i])
        s[i]="maxretry = 2\n"
        break;
    end
end
s1=""
for i=1:length(s)
    global s1
    s1=string(s1,s[i])
end
close(io)
io=open("/etc/fail2ban/jail.conf","w")
write(io,s1)
close(io)
run(`systemctl stop fail2ban`)
run(`systemctl start fail2ban`)
run(`systemctl enable fail2ban`)
run(`ufw allow 22/tcp`)
run(`ufw enable`)
