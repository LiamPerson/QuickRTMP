# QuickRTMP
A bash script that installs NGINX with RTMP module.

Installs NGINX and dependencies:
Current dependencies:
<ul>
  <li><code>build-essential</code></li>
  <li><code>libpcre3</code></li>
  <li><code>libpcre3-dev</code></li>
  <li><code>libssl-dev</code></li>
  <li><code>unzip</code></li>
  <li><code>zlib1g</code></li>
  <li><code>zlib1g-dev</code></li>
  <li><code>ufw</code> (Optional for firewall)</li>
</ul>

# Installation & Usage
<ol>
  <li>Put file onto target machine. e.g: <code>wget https://raw.githubusercontent.com/YeloPartyHat/QuickRTMP/master/install.sh</code></li>
  <li>Navigate to the location you put the files using <code>cd</code></li>
  <li>Run file using <code>sudo bash install.sh</code></li>
  <li>Follow in-console prompts</li>
</ol>

# Notes
<ul>
  <li>You may notice you can't immediately run the file when you place it. This is because you don't have the adequate permissions. To fix this, use: <code>chmod +x file.sh</code></li>
</ul>

RTMP by default uses port 1935.

All NGINX files are located in <code>/usr/local/nginx</code>. This means the config file is located at <code>/usr/local/nginx/conf/nginx.conf</code>

<hr>

<i>Use with caution! <br>I am not responsible if you accidentally register the wrong domain or remove something important!</i>
