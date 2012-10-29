
cd `dirname $0`
echo '-- start watching'

stylus -o examples/ -w page/*styl &
stylus -o src/ -w script/*styl &
jade -O examples/ -wP page/*jade &
coffee -o src/ -wbc script/*coffee &
coffee -o examples/ -wbc page/*coffee &
doodle examples/ src/ &

read

pkill -f doodle
pkill -f stylus
pkill -f jade
pkill -f coffee

echo '-- stop watching'