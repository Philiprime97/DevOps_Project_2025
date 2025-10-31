<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{{- if . }}{{- escapeXML (index . 0).Target }} - Trivy Report - {{ now }}{{- else }}Trivy Report{{- end }}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    :root {
      --low: #66bb6a;
      --medium: #fbc02d;
      --high: #ff9800;
      --critical: #d32f2f;
      --unknown: #9e9e9e;
      --primary: #1976d2;
      --accent: #2196f3;
      --bg: #f0f4f8;
      --text: #333;
    }

    body {
      font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      background-color: var(--bg);
      margin: 0;
      padding: 20px;
      color: var(--text);
    }

    /* Header styling */
    .report-header {
      text-align: center;
      margin-bottom: 1.5em;
    }

    .report-title {
      font-size: 2em;
      font-weight: bold;
      color: var(--primary);
      margin-bottom: 0.3em;
    }

    .report-target {
      display: inline-block;
      background-color: var(--accent);
      color: #fff;
      padding: 0.3em 0.6em;
      border-radius: 8px;
      font-size: 1em;
      margin-bottom: 0.3em;
    }

    .report-os {
      display: inline-block;
      margin-left: 0.5em;
      font-size: 0.9em;
      font-weight: normal;
      color: var(--text);
    }

    .report-date {
      font-size: 0.95em;
      color: var(--high);
      font-weight: bold;
    }

    .report-card {
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      margin: 20px auto;
      padding: 20px;
      max-width: 1200px;
    }

    .group-header {
      font-size: 1.5em;
      font-weight: bold;
      color: #fff;
      background: linear-gradient(to right, var(--primary), var(--accent));
      padding: 10px;
      border-radius: 8px;
      margin-bottom: 10px;
      text-align: center;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
    }

    th, td {
      padding: 0.75em;
      border-bottom: 1px solid #e0e0e0;
      vertical-align: middle;
      text-align: center;
    }

    td.links {
      text-align: left;
    }

    th {
      background-color: var(--accent);
      color: #fff;
      font-weight: 600;
    }

    tr:hover {
      background-color: #f9f9f9;
    }

    /* Severity badges wrapper */
    td.severity div {
      display: flex;
      justify-content: center;
      align-items: center;
      font-weight: 600;
      color: #fff;
      padding: 0.3em 0.6em;
      border-radius: 20px;
      font-size: 0.9em;
      text-align: center;
      width: 100%;
      height: 100%;
      box-sizing: border-box;
    }

    tr.severity-LOW td.severity div { background-color: var(--low); }
    tr.severity-MEDIUM td.severity div { background-color: var(--medium); }
    tr.severity-HIGH td.severity div { background-color: var(--high); }
    tr.severity-CRITICAL td.severity div { background-color: var(--critical); }
    tr.severity-UNKNOWN td.severity div { background-color: var(--unknown); }

    .links a {
      display: block;
      color: var(--primary);
      text-decoration: none;
      margin-bottom: 0.3em;
      word-break: break-word;
      transition: color 0.2s ease;
    }

    .links a:hover {
      color: #0d47a1;
      text-decoration: underline;
    }

    a.toggle-more-links {
      cursor: pointer;
      color: var(--high);
      font-weight: bold;
      font-size: 0.9em;
    }

    td.links[data-more-links="off"] a:nth-of-type(n+5) {
      display: none;
    }

    @media (max-width: 768px) {
      table, th, td {
        font-size: 0.9em;
      }
    }
  </style>

  <script>
    window.onload = function() {
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
  <!-- Pretty header -->
  <div class="report-header">
    <h1 class="report-title">Trivy Report</h1>
    <div class="report-target">
      {{- escapeXML (index . 0).Target }}
      <span class="report-os">({{- escapeXML (index . 0).OS }})</span>
    </div>
    <div class="report-date">{{ now }}</div>
  </div>

  {{- range . }}
  <div class="report-card">
    <div class="group-header">{{ .Type | toString | escapeXML }}</div>

    <!-- Vulnerabilities Table -->
    {{- if eq (len .Vulnerabilities) 0 }}
    <p><strong>No Vulnerabilities found</strong></p>
    {{- else }}
    <table>
      <tr>
        <th>Package</th>
        <th>Vulnerability ID</th>
        <th>Severity</th>
        <th>Installed Version</th>
        <th>Fixed Version</th>
        <th>Links</th>
      </tr>
      {{- range .Vulnerabilities }}
      <tr class="severity-{{ escapeXML .Vulnerability.Severity }}">
        <td>{{ escapeXML .PkgName }}</td>
        <td>{{ escapeXML .VulnerabilityID }}</td>
        <td class="severity">
          <div>{{ escapeXML .Vulnerability.Severity }}</div>
        </td>
        <td>{{ escapeXML .InstalledVersion }}</td>
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
    </table>
    {{- end }}

    <!-- Misconfigurations Table -->
    {{- if eq (len .Misconfigurations) 0 }}
    <p><strong>No Misconfigurations found</strong></p>
    {{- else }}
    <table>
      <tr>
        <th>Type</th>
        <th>Misconf ID</th>
        <th>Check</th>
        <th>Severity</th>
        <th>Message</th>
      </tr>
      {{- range .Misconfigurations }}
      <tr class="severity-{{ escapeXML .Severity }}">
        <td>{{ escapeXML .Type }}</td>
        <td>{{ escapeXML .ID }}</td>
        <td>{{ escapeXML .Title }}</td>
        <td class="severity">
          <div>{{ escapeXML .Severity }}</div>
        </td>
        <td>
          {{ escapeXML .Message }}<br>
          <a href={{ escapeXML .PrimaryURL | printf "%q" }} target="_blank">{{ escapeXML .PrimaryURL }}</a>
        </td>
      </tr>
      {{- end }}
    </table>
    {{- end }}
  </div>
  {{- end }}
  {{- else }}
  <h1>Trivy Returned Empty Report</h1>
  {{- end }}
</body>
</html>
