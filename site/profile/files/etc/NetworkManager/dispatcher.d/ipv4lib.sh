v4dec() {
        for i; do
                echo $i | {
                        IFS=./
                        read a b c d e
                        test -z "$e" && e=32
                        echo -n "$((a<<24|b<<16|c<<8|d)) $((-1<<(32-e))) "
                }
        done
}

v4test() {
        v4dec $1 $2 | {
                read addr1 mask1 addr2 mask2
                if (( (addr1&mask2) == (addr2&mask2) && mask1 >= mask2 )); then
                        return 0
                else
                        return 1
                fi
        }
}

in_any_net() {
        for i in $(seq 0 $((IP4_NUM_ADDRESSES - 1)))
        do
                varname=IP4_ADDRESS_$i
                curr_addr=${!varname}
                v4test $1 $curr_addr && return 0
        done


        return 1
}