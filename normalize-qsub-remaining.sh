cat "run-normalize-todo.txt" | while read tf; do 
	bash normalize-qsub.sh $tf
done