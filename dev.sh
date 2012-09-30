
cd `dirname $0`
echo '-- start watching'

coffee -o page/ -wbc script/*coffee &
coffee -o page/ -wbc src/*coffee &
stylus -o page/ -w src/*styl &
stylus -o page/ -w script/*styl &
jade -O page/ -wP src/*jade &
doodle page/ &

read

pkill -f coffee
pkill -f stylus
pkill -f jade
pkill -f doodle

echo '-- stop watching'