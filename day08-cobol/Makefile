default:
	@cobc -c -free -x main.cob
	@cobc -c -free util.cob
	@cobc -c -free counter.cob
	@cobc -c -free move-row.cob
	@cobc -c -free move-column.cob
	@cobc -c -free create-rect.cob
	@cobc -x -o main main.o util.o move-column.o move-row.o create-rect.o counter.o