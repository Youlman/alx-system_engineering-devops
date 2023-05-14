500 Internal Server Error Postmortem
Issue Summary:
Between 10:00 AM and 11:20 AM (UTC), any requests sent to Web stack debugging WordPress server instances led to a 500 error response. This problem impacted the entire system's traffic, completely preventing access to any web content. The main reason behind this issue was a typo in the configuration files of the WordPress stack, resulting in an error when attempting to serve any response due to a nonexistent file.

Timeline (all times UTC)
10:00 AM: Commencement of configuration push
10:03 AM: Onset of outage
10:04 AM: I were alerted when I want access to web page
10:15 AM: Apache and PHP service logs were examined, but no relevant information was found
10:20 AM: Real-time tracing of the Apache service initiated to monitor its response to requests
10:25 AM: Discovery of attempts to load a non-existent file
10:45 AM: Typo identified upon inspecting the WordPress configuration files
10:50 AM: Typo rectified and multiple request tests conducted, resulting in successful 200 responses from the running server
11:00 AM: Creation of a puppet script for efficient resolution of the issue across all other server instances
11:30 AM: Testing of all instances completed, with successful responses observed for all requests made. Traffic fully restored, reaching 100% online status.
Root cause:
At 10:00 AM UTC, a configuration change was to the branch of WordPress Server without undergoing prior testing in the development environment. This change aimed to incorporate new PHP files for optimising dynamic functions on the server's landing page. As part of this update, the WordPress configuration needed to be modified to specify the paths of these new files. Unfortunately, one of the paths contained a typographical error, resulting in the server encountered an ENOENT (No such file or directory) error. This error disrupted the response operations of the system across all server instances.
Despite the issue, the Apache service remained functional, and no error logs were recorded for this process. The PHP configuration was set to its default state, which meant that Internal Server Errors were not being logged by PHP.
Resolution and Recovery:
At 10:00 AM UTC ,I notice the server consistently responding with 500 errors. I swiftly initiated an investigation and escalated the issue. By 10:10 AM UTC, It was confirmed that neither the Apache nor PHP error logs contained any relevant information regarding the problem.

With no valuable insights from the logs, the response team decided to employ the strace Linux utility to trace the Apache service and analyze the system's behavior upon receiving requests. Upon meticulous examination, they discovered that each response attempt involved an attempt to load a non-existent file.

lstat("/var/www/html/wp-includes/class-wp-locale.phpp", 0x7ffc69aed4f0) = -1 ENOENT (No such file or directory)

Further investigation of the "wp-includes" directory revealed that the actual file had a .php extension instead of .phpp, indicating a typo in the WordPress configuration.

By 10:50 AM UTC -05:00, the team rectified the typo in the "/var/www/html/wp-settings.php" file and conducted tests on one of the server instances to ensure that all requests received successful responses.

Finally, by 11:00 AM UTC a puppet script was developed to address any potential failures in other parts of the server and was deployed across all system instances.

At 11:30 AM UTC -05:00, the system regained 100% operational status, with all traffic functioning smoothly.

Corrective and preventative measures 

Following the resolution of the issue, I conducted an analysis to identify measures that could enhance response and prevent similar problems in the future. The following actions are currently being implemented:

Disabling the existing configuration release mechanism and implementing a CI (Continuous Integration) deployment mechanism that includes thorough testing throughout the implementation process for every new change.
Enabling comprehensive error logging on the PHP service, which is typically deactivated by default, to capture detailed information for troubleshooting.
Developing Puppet templates that can be swiftly implemented to address various server errors, such as executing bash code, updating deprecated software, or modifying lines in files.
These actions aim to bolster response capabilities and proactively mitigate potential issues, ensuring a more robust and efficient system moving forward.

