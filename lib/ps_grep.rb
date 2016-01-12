# ps_grep
# Find a process using name pattern
# Author: Jackie.ju@gmail.com
# 
require 'rubygems'
require 'rbconfig'

s = Config::CONFIG['target_os']
if s.index("linux")
    $_OS_TYPE = "linux"
elsif s.index("darwin")
    $_OS_TYPE = "darwin"
end

def find_process(*pattern)
    mongrels = []
    
    s = pattern.join(" | grep ")

    command = "ps aux | grep -v grep | grep #{s}"
    p "command=>#{command}"
    r = `#{command}`
    print "==>command output<===\n#{r}"
    print "==>command output end<===\n"
    
    if $_OS_TYPE == "linux"
    
    
        r.scan(/^(.*?)\s+(\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+)\s+(\d+)\s+(.*?)\s+(.*?)\s+(.*?)\s+(\d+:\d+\.\d+)\s+(.*?)$/){|m|
            mongrels.push({
                :user=>m[0].strip,
                :pid=>m[1],
                :cpu=>m[2],
                :mem1=>m[3],
                :mem2=>m[4],
                :mem3=>m[5],
                :start=>m[8],
                :time=>m[9],
                :cmd=>m[10].strip
            })
        }
    elsif $_OS_TYPE == "darwin"
        r.scan(/^(.*?)\s+(\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+)\s+(\d+)\s+(.*?)\s+(.*?)\s+(.*?)\s+(\d+:\d+\.\d+)\s+(.*?)$/){|m|
            mongrels.push({
                :user=>m[0].strip,
                :pid=>m[1],
                :cpu=>m[2],
                :mem1=>m[3],
                :mem2=>m[4],
                :mem3=>m[5],
                :start=>m[8],
                :time=>m[9],
                :cmd=>m[10].strip
            })
        }
    else
        p "OS #{$_OS_TYPE} is not supported"
    end 
    
    return mongrels
end

# get memory usage of current process
def current_proc_used_mem
    #pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)
    #`ps -o rss -p #{$$}`.chomp.split("\n").last.to_i
    #`ps -o rss -p #{$$}`.strip.split.last.to_i * 1024
    `ps -o rss= -p #{Process.pid}`.to_i 
end
# test
=begin
ret =  find_process("ruby", "")
p "====>"
p ret
=end
