all:
	jg jg_do.tcl
PHONY: clean
clean:
	rm -rf jgproject
.PHONY: send recieve
send:
	sshpass -f ~/.fakultet_pass rsync -avz --checksum -e "ssh -p 55740" . lazar.mincic@147.91.175.237:/nethome/lazar.mincic/git/fv/sort_ip
recieve:
	sshpass -f ~/.fakultet_pass rsync -avz --checksum -e "ssh -p 55740" lazar.mincic@147.91.175.237:/nethome/lazar.mincic/git/fv/sort_ip/ .
