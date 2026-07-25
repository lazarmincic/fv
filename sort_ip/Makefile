all:
	jg jg_do.tcl
PHONY: clean
clean:
	rm -rf jgproject
.PHONY: send recieve
send:
	rsync -rvz --checksum -e "ssh -p 55740" . lazar.mincic@147.91.175.237:/nethome/lazar.mincic/scp/sort_ip
recieve:
	rsync -rvz --checksum -e "ssh -p 55740" lazar.mincic@147.91.175.237:/nethome/lazar.mincic/scp/sort_ip/ .
