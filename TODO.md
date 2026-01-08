1. Check dependencies
2. Check folder structure
3. Read IP-Range file. Hardcoded
4. For each line, start Nmap 
5. Single thread for now
6. For each host-range, create separate Metasploit-importable xml

—————
TODO
- Display Banner open startup
- Format checks
- Provide default country-specific ip-ranges
- Upload result
- Zombie Scan
- More scan options 
- Get rid of those emoticons - Use regular characters
- Colors for output?
- Tests?
- Save offset to get state between run


NEXT STEPS:
- Upload scan results to some stealthy location (compromised host?)
- C2 server consumes those reports, and import to db_nmap
- C2 server exports list of targets for certain ports (even version?)
- Other workers consume, and provide further scans
- HTTP Servers - version enumeration? Stack enumeration? Auto wordpress detector?
- 

