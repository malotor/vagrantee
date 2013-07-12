#
# Workaround for the default phpmyadmin modules facter
#
require 'facter'

if File.exist?("/etc/phpmyadmin.facts")
    File.readlines("/etc/phpmyadmin.facts").each do |line|
        if line =~ /^(.+)=(.+)$/
            var = "pma_"+$1.strip;
            val = $2.strip

            Facter.add(var) do
                setcode { val }
            end
        end
    end
else
    Facter.add("pma_mysql_root_password") do
        setcode { "root" }
    end

    Facter.add("pma_controluser_password") do
        setcode { "root" }
    end
end
