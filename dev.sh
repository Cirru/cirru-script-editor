
cd `dirname $0`
echo '-- start watching'

stylus -o page/ -w src/*styl &
stylus -o page/ -w script/*styl &
jade -O page/ -wP src/*jade &
doodle page/ script/ &

read

pkill -f stylus
pkill -f jade
pkill -f doodle

echo '-- stop watching'