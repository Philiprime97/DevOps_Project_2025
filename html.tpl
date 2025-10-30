<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{{- if . }}{{- escapeXML (index . 0).Target }} - Trivy Report - {{ now }}{{- else }}Trivy Report{{- end }}</title>
  <style>
    body {
      font-family: Arial, Helvetica, sans-serif;
      background-color: #f5f5f5;
      margin: 20px;
      color: #333;
    }

    h1 {
      text-align: center;
      color: #222;
      margin-bottom: 1em;
    }

    table {
      border-collapse: collapse;
      width: 90%;
      margin: 0 auto 2em auto;
      background-color: #fff;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }

    th, td {
      border: 1px solid #ccc;
      padding: 0.5em;
      text-align: left;
      vertical-align: top;
    }

    th {
      background-color: #007acc;
      color: #fff;
    }

    .group-header th {
      background-color: #005a99;
      font-size: 1.5em;
      text-align: center;
    }

    .sub-header th {
      background-color: #0094ff;
      font-size: 1.2em;
    }

    .severity {
      font-weight: bold;
      text-align: center;
      color: #fff;
      padding: 0.2em 0.5em;
      border-radius: 4px;
      display: inline-block;
      min-width: 60px;
    }

    .severity-LOW .severity { background-color: #5fbb31; }
    .severity-MEDIUM .severity { background-color: #e9c600; }
    .severity-HIGH .severity { background-color: #ff8800; }
    .severity-CRITICAL .severity { background-color: #e40000; }
    .severity-UNKNOWN .severity { background-color: #747474; }

    .links a {
      display: block;
      color: #007acc;
      text-decoration: none;
      margin-bottom: 0.2em;
      word-break: break-all;
    }

    .links a:hover {
      text-decoration: underline;
    }

    a.toggle-more-links {
      cursor: pointer;
      color: #ff6600;
      font-weight: bold;
    }

    td.pkg-name, td.pkg-version, td.misconf-type, td.misconf-check {
      white-space: nowrap;
    }

    td.links[data-more-links="off"] a:nth-of-type(n+5) {
      display: none;
    }
  </style>

  <script>
    window.onload = function() {
      // Toggle "more links" visibility
      document.querySelectorAll('a.toggle-more-links').forEach(function(toggleLink) {
        toggleLink.onclick = function() {
          var parent = toggleLink.parentElement;
          var expanded = parent.getAttribute("data-more-links");
          parent.setAttribute("data-more-links", expanded === "on" ? "off" : "on");
          return false;
        };
      });
    };
  </script>
</head>

<body>
{{- if . }}
  <h1>{{- escapeXML (index . 0).Target }} - Trivy Report - {{ now }}</h1>

  <table>
  {{- range . }}
    <tr class="group-header"><th colspan="6">{{ .Type | toString | escapeXML }}</th></tr>

    {{- if eq (len .Vulnerabilities) 0 }}
      <tr><th colspan="6">No Vulnerabilities found</th></tr>
    {{- else }}
      <tr class="sub-header">
        <th>Package</th>
        <th>Vulnerability ID</th>
        <th>Severity</th>
        <th>Installed Version</th>
        <th>Fixed Version</th>
        <th>Links</th>
      </tr>
      {{- range .Vulnerabilities }}
        <tr class="severity-{{ escapeXML .Vulnerability.Severity }}">
          <td class="pkg-name">{{ escapeXML .PkgName }}</td>
          <td>{{ escapeXML .VulnerabilityID }}</td>
          <td class="severity">{{ escapeXML .Vulnerability.Severity }}</td>
          <td class="pkg-version">{{ escapeXML .InstalledVersion }}</td>
          <td>{{ escapeXML .FixedVersion }}</td>
          <td class="links" data-more-links="off">
            {{- range .Vulnerability.References }}
              <a href={{ escapeXML . | printf "%q" }} target="_blank">{{ escapeXML . }}</a>
            {{- end }}
            {{- if gt (len .Vulnerability.References) 3 }}
              <a class="toggle-more-links">Toggle more links</a>
            {{- end }}
          </td>
        </tr>
      {{- end }}
    {{- end }}

    {{- if eq (len .Misconfigurations) 0 }}
      <tr><th colspan="6">No Misconfigurations found</th></tr>
    {{- else }}
      <tr class="sub-header">
        <th>Type</th>
        <th>Misconf ID</th>
        <th>Check</th>
        <th>Severity</th>
        <th>Message</th>
      </tr>
      {{- range .Misconfigurations }}
        <tr class="severity-{{ escapeXML .Severity }}">
          <td class="misconf-type">{{ escapeXML .Type }}</td>
          <td>{{ escapeXML .ID }}</td>
          <td class="misconf-check">{{ escapeXML .Title }}</td>
          <td class="severity">{{ escapeXML .Severity }}</td>
          <td style="white-space: normal;">
            {{ escapeXML .Message }}
            <br>
            <a href={{ escapeXML .PrimaryURL | printf "%q" }} target="_blank">{{ escapeXML .PrimaryURL }}</a>
          </td>
        </tr>
      {{- end }}
    {{- end }}

  {{- end }}
  </table>
{{- else }}
  <h1>Trivy Returned Empty Report</h1>
{{- end }}
</body>
</html>
