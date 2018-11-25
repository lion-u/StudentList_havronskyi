# Create a virtual network.
$subnet = New-AzureRmVirtualNetworkSubnetConfig -Name $(Env: subnetname) -AddressPrefix $(Env: subnetIP)

$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $(Env: resourceGroup) -Name $(Env: vnetname) -AddressPrefix $(Env: vnetIP) -Location $(Env: location) -Subnet $subnet

# Retrieve the subnet object for use later
$subnet=$vnet.Subnets[0]

# Create a public IP address.
$publicIp = New-AzureRmPublicIpAddress -ResourceGroupName $(Env: resourceGroup) -Name $(Env: pipname) -Location $(Env: location) -AllocationMethod Dynamic

# Create a new IP configuration
$gipconfig = New-AzureRmApplicationGatewayIPConfiguration -Name $(Env: gatewayIP01) -Subnet $subnet

# Create a backend pool with the hostname of the web app
$pool = New-AzureRmApplicationGatewayBackendAddressPool -Name $(Env: appGatewayBackendPool) -BackendFqdns $(Env: webappFQDN1),$(Env: webappFQDN1)

# Define the status codes to match for the probe
$match = New-AzureRmApplicationGatewayProbeHealthResponseMatch -StatusCode 200-399

# Create a probe with the PickHostNameFromBackendHttpSettings switch for web apps
$probeconfig = New-AzureRmApplicationGatewayProbeConfig -name $(Env: webappprobe) -Protocol Http -Path / -Interval 30 -Timeout 120 -UnhealthyThreshold 3 -PickHostNameFromBackendHttpSettings -Match $match

# Define the backend http settings
$poolSetting = New-AzureRmApplicationGatewayBackendHttpSettings -Name $(Env: appGWBackendHttpSettings) -Port 80 -Protocol Http -CookieBasedAffinity Disabled -RequestTimeout 120 -PickHostNameFromBackendAddress -Probe $probeconfig

# Create a new front-end port
$fp = New-AzureRmApplicationGatewayFrontendPort -Name $(Env: frontendport01)  -Port 80

# Create a new front end IP configuration
$fipconfig = New-AzureRmApplicationGatewayFrontendIPConfig -Name $(Env: fipconfig01) -PublicIPAddress $publicIp

# Create a new listener using the front-end ip configuration and port created earlier
$listener = New-AzureRmApplicationGatewayHttpListener -Name $(Env: listener01) -Protocol Http -FrontendIPConfiguration $fipconfig -FrontendPort $fp

# Create a new rule
$rule = New-AzureRmApplicationGatewayRequestRoutingRule -Name $(Env: rule01) -RuleType Basic -BackendHttpSettings $poolSetting -HttpListener $listener -BackendAddressPool $pool

# Define the application gateway SKU to use
$sku = New-AzureRmApplicationGatewaySku -Name Standard_Small -Tier Standard -Capacity 2

# Create the application gateway
New-AzureRmApplicationGateway -Name $(Env: appgwname) -ResourceGroupName $(Env: resourceGroup) -Location $(location) -BackendAddressPools $pool -BackendHttpSettingsCollection $poolSetting -Probes $probeconfig -FrontendIpConfigurations $fipconfig  -GatewayIpConfigurations $gipconfig -FrontendPorts $fp -HttpListeners $listener -RequestRoutingRules $rule -Sku $sku