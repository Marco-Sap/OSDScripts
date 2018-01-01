<#
.SYNOPSIS
   Configuration Manager Task Sequence FrontEnd
.DESCRIPTION
   This FrontEnd
.AUTHOR
   Marco Sap 
.VERSION
   2.0.0
.EXAMPLE
   FrontEnd.ps1
.DISCLAIMER
   This script code is provided as is with no guarantee or waranty
   concerning the usability or impact on systems and may be used,
   distributed, and modified in any way provided the parties agree
   and acknowledge that Microsoft or Microsoft Partners have neither
   accountabilty or responsibility for results produced by use of
   this script.

   Microsoft will not provide any support through any means.
#>
[CmdletBinding()]
 Param(
  [Switch]$DebugFrontEnd
 )

Add-Type -AssemblyName presentationframework, presentationcore

$InputXAML = @"
<Window x:Name="window" x:Class="Example.MainWindow"
xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
Title="MainWindow" Height="440" Width="640" WindowStyle="None" AllowsTransparency="True" Background="Transparent" Topmost="True" WindowStartupLocation="CenterScreen" >

<Window.Resources>

<!-- TextBox -->
<Style x:Key="TextBoxStyle" TargetType="{x:Type TextBox}">
    <Setter Property="HorizontalAlignment" Value="Left" />
    <Setter Property="VerticalAlignment" Value="Top" />
    <Setter Property="VerticalContentAlignment" Value="Center"/>
    <Setter Property="TextAlignment" Value="Center"/>
    <Setter Property="Width" Value="240" />
    <Setter Property="Height" Value="25" />
    <Setter Property="Foreground" Value="Black" />
    <Setter Property="Background" Value="White" />
    <Setter Property="Template">
        <Setter.Value>
            <ControlTemplate x:Key="TextBoxTemplate" TargetType="{x:Type TextBox}">
                <Border Background="{TemplateBinding Background}" BorderBrush="Black" BorderThickness="1" CornerRadius="5" > 
                    <ScrollViewer x:Name="PART_ContentHost"/>
                </Border>
            </ControlTemplate>
        </Setter.Value>
    </Setter>
</Style>

<!-- Button -->
<Style x:Key="ButtonStyle" TargetType="{x:Type Button}">
    <Setter Property="Padding" Value="0" />
    <Setter Property="Foreground" Value="White" />
    <Setter Property="Background" Value="Transparent" />
    <Setter Property="FontSize" Value="20" />
    <Setter Property="FontWeight" Value="Normal" />
    <Setter Property="FontFamily" Value="Segoe UI" />
    <Setter Property="Template">
        <Setter.Value>
            <ControlTemplate TargetType="{x:Type Button}">
                <Border Name="Border" Background="{TemplateBinding Background}">
                    <ContentPresenter Name="Content" HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" 
                                          Margin="{TemplateBinding Padding}" 
                                          RecognizesAccessKey="True" 
                                          SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}" 
                                          VerticalAlignment="{TemplateBinding VerticalContentAlignment}"/>
                </Border>
                <ControlTemplate.Triggers>
                    <Trigger Property="IsMouseOver" Value="True">
                        <Setter Property="Foreground" Value="White" />
                        <Setter TargetName="Content" Property="RenderTransform" >
                            <Setter.Value>
                                <ScaleTransform ScaleX="1.3" ScaleY="1.3" CenterX="15" CenterY="15"  />
                            </Setter.Value>
                        </Setter>
                    </Trigger>
                    <Trigger Property="IsPressed" Value="True">
                        <Setter Property="Foreground" Value="White" />
                        <Setter TargetName="Content" Property="RenderTransform" >
                            <Setter.Value>
                                <ScaleTransform ScaleX=".95" ScaleY=".95" />
                            </Setter.Value>
                        </Setter>
                    </Trigger>
                    <Trigger Property="IsFocused" Value="True">
                    </Trigger>
                </ControlTemplate.Triggers>
            </ControlTemplate>
        </Setter.Value>
    </Setter>
</Style>

<!-- ComboBoxButton -->
<Style x:Key="ComboBoxButtonStyle" TargetType="{x:Type ToggleButton}">  
    <Setter Property="Template">  
        <Setter.Value>  
            <ControlTemplate TargetType="{x:Type ToggleButton}">  
                <Border x:Name="ButtonBorder" Background="White" CornerRadius="0,5,5,0" BorderThickness="0,1,1,1" BorderBrush="Black">  
                    <ContentPresenter />  
                </Border>  
            </ControlTemplate>  
        </Setter.Value>  
    </Setter>  
</Style>

<!-- ComboBoxTextBoxTop -->
<Style x:Key="ComboBoxTextBoxStyle" TargetType="{x:Type TextBox}">
    <Setter Property="Background" Value="White" />
    <Setter Property="Template">
        <Setter.Value>
            <ControlTemplate TargetType="{x:Type TextBox}">
                <Grid>
                    <Border CornerRadius="5,0,0,5" BorderThickness="1,1,0,1" Background="{TemplateBinding Background}" BorderBrush="Black" >
                   <!--     <ScrollViewer x:Name="PART_EditableTextBox"/> -->
                    </Border>
                </Grid>
            </ControlTemplate>  
        </Setter.Value>  
    </Setter>  
</Style>

<Style x:Key="ComboxItemStyle" TargetType="{x:Type ComboBoxItem}">
    <Setter Property="Foreground" Value="Black" />
</Style>

<!-- ComboBoxAssembly -->
<Style x:Key="ComboBoxStyle" TargetType="{x:Type ComboBox}">
    <Setter Property="HorizontalContentAlignment" Value="Center"/>  
    <Setter Property="VerticalContentAlignment" Value="Center"/>  
    <Setter Property="Background" Value="White" />
    <Setter Property="ItemContainerStyle" Value="{StaticResource ComboxItemStyle}"/>
    <Setter Property="Template">  
        <Setter.Value>  
            <ControlTemplate TargetType="{x:Type ComboBox}">  
                <Grid>  
                    <Grid.ColumnDefinitions>  
                        <ColumnDefinition/>  
                        <ColumnDefinition MaxWidth="18"/>  
                    </Grid.ColumnDefinitions>  
                    <TextBox Name="PART_EditableTextBox" Style="{StaticResource ComboBoxTextBoxStyle}" Padding="5,0,0,0" Height="{TemplateBinding Height}" />  
                    <ToggleButton Grid.Column="1" Margin="0" Height="{TemplateBinding Height}" Style="{StaticResource ComboBoxButtonStyle}" Focusable="False" IsChecked="{Binding Path=IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}" ClickMode="Press">  
                    <Path Grid.Column="1" HorizontalAlignment="Center" VerticalAlignment="Center" Data="M 0 0 L 4 4 L 8 0 Z" Fill="DodgerBlue" />  
                    </ToggleButton>  
                    <ContentPresenter Name="ContentSite" Content="{TemplateBinding SelectionBoxItem}" ContentTemplate="{TemplateBinding SelectionBoxItemTemplate}" ContentTemplateSelector="{TemplateBinding ItemTemplateSelector}" VerticalAlignment="Center" HorizontalAlignment="Center" Margin="5,0,0,0" />  
                        <Popup Name="Popup" Placement="Bottom" IsOpen="{TemplateBinding IsDropDownOpen}" AllowsTransparency="True" Focusable="False" PopupAnimation="Slide" >  
                            <Grid Name="DropDown" SnapsToDevicePixels="True" MinWidth="{TemplateBinding ActualWidth}" MaxHeight="{TemplateBinding MaxDropDownHeight}" >

                            <Border x:Name="DropDownBorder" BorderThickness="1" CornerRadius="5" BorderBrush="Black"/>  
                            <ScrollViewer Margin="3,3,3,3" SnapsToDevicePixels="True" >  
                              <StackPanel IsItemsHost="True" KeyboardNavigation.DirectionalNavigation="Contained" Background="White" />
                            </ScrollViewer>

                            </Grid>
                        </Popup>  
                </Grid>  
            </ControlTemplate>  
        </Setter.Value>  
    </Setter>  
</Style>

<!-- Label -->
<Style x:Key="{x:Type Label}" TargetType="Label">
    <Setter Property="HorizontalAlignment" Value="Left" />
    <Setter Property="VerticalAlignment" Value="Top" />
    <Setter Property="HorizontalContentAlignment" Value="Left" />
    <Setter Property="VerticalContentAlignment" Value="Center" />
    <Setter Property="Foreground" Value="White" />
    <!-- <Setter Property="FontSize" Value="12" /> -->
    <Setter Property="FontFamily" Value="Segoe UI" />
    <Setter Property="Padding" Value="5,0,0,0" />
    <Setter Property="Width" Value="240" />
    <Setter Property="Height" Value="20" />
</Style>

</Window.Resources>

    <Grid x:Name="MainGrid" Margin="20" Background="#383838" >
        <Grid.Effect>
            <DropShadowEffect BlurRadius="15" Direction="320" RenderingBias="Quality" ShadowDepth="10" Opacity="0.5" />
        </Grid.Effect>
        <Image Name="image1" Height="32" Width="32" HorizontalAlignment="Left" VerticalAlignment="Top" />
        <Image Name="image2" Height="32" Width="32" HorizontalAlignment="Right" VerticalAlignment="Top" />
        <TextBlock x:Name="MenuHeader" TextWrapping="Wrap" Text="Operating System Deployment" TextAlignment="Center" Foreground="White" FontFamily="Segoe UI Semibold" FontSize="25" VerticalAlignment="Top" HorizontalAlignment="Center" Height="34"/>
        <Label x:Name="HostNameBoxLabel" Content="Computer Name:" FontWeight="Bold" />
        <TextBox x:Name="HostNameBox" Style="{StaticResource TextBoxStyle}" ToolTip="Enter a NETBIOS Name for the PC" />
        <Label x:Name="ModelNumberLabel" Content="Model:" FontWeight="Bold" />
        <Label x:Name="ModelNumber" Content="(gwmi model)" />
        <Label x:Name="SerialNumberLabel" Content="Serial Number:" FontWeight="Bold" />
        <Label x:Name="SerialNumber" Content="(gwmi serialnumber)" />
        <Label x:Name="RAMInstalledLabel" Content="RAM Installed:" FontWeight="Bold" />
        <Label x:Name="RAMInstalled" Content="(gwmi totalram)" />

        <!--
        <Label x:Name="TPMFoundLabel" Content="TPM Available" FontWeight="Bold" Width="70" Padding="0" HorizontalContentAlignment="Center" FontSize="9" />
        <Label x:Name="TPMFound" Width="70"/>
        <Label x:Name="TPMOwnerLabel" Content="TPM Ownership" FontWeight="Bold" Width="70" Padding="0" HorizontalContentAlignment="Center" FontSize="9" />
        <Label x:Name="TPMOwner" Width="70"/>
        <Label x:Name="OnPowerLabel" Content="Power State" FontWeight="Bold" Width="70" Padding="0" HorizontalContentAlignment="Center" FontSize="9" />
        <Label x:Name="OnPower" Width="70" />
        -->

        <Label x:Name="ComboBoxLabel" Content="Type:" FontWeight="Bold" />
        <ComboBox x:Name="PresetDropDown" Style="{StaticResource ComboBoxStyle}" Width="240" HorizontalAlignment="Left" VerticalAlignment="Top" Height="25" >
            <ComboBoxItem ToolTip="(1703)">Laptop_Type_Bitlocker</ComboBoxItem>
            <ComboBoxItem ToolTip="(1709)">Laptop_Type_MBAM</ComboBoxItem>
            <ComboBoxItem ToolTip="(1703)">laptop_Type_3</ComboBoxItem>   
            <ComboBoxItem ToolTip="(1709)">Desktop_Type_4</ComboBoxItem>
        </ComboBox>

        <StackPanel x:Name="Panel1" Width="240" Height="25" HorizontalAlignment="Left" VerticalAlignment="Top" Orientation="Horizontal" >
            <CheckBox x:Name="LanguageCheckBox" VerticalAlignment="Center" >
                <TextBlock Foreground="White" Text="Nederlands" />
            </CheckBox>
        </StackPanel>

        <StackPanel x:Name="Panel2" Width="240" Height="25" HorizontalAlignment="Left" VerticalAlignment="Top" Orientation="Horizontal" >
            <RadioButton GroupName="Encryption" x:Name="BitLockerCheckBox" VerticalAlignment="Center" ToolTip="Enables BitLocker on the machine if the TPM is enabled and activated." ToolTipService.ShowOnDisabled="True" >
                <TextBlock Foreground="White" Text="Enable Bitlocker" />
            </RadioButton>
            <RadioButton GroupName="Encryption" x:Name="MBAMCheckBox" VerticalAlignment="Center" ToolTip="Enables MBAM on the machine if the TPM is enabled and activated." ToolTipService.ShowOnDisabled="True" Margin="10,0,0,0">
                <TextBlock Foreground="White" Text="Enable MBAM" />
            </RadioButton>
        </StackPanel>

        <StackPanel x:Name="Panel3" Width="240" Height="26" HorizontalAlignment="Left" VerticalAlignment="Top" Orientation="Horizontal" >
            <RadioButton GroupName="Branch" x:Name="Branch1" IsChecked="True" ToolTip="Version 1709" VerticalContentAlignment="Center" >
                <TextBlock Foreground="White" Text="Pilot" />
            </RadioButton>
            <RadioButton GroupName="Branch" x:Name="Branch2" Margin="10,0,0,0" ToolTip="Version 1703" VerticalContentAlignment="Center" >
                <TextBlock Foreground="White" Text="Production" />
            </RadioButton>
        </StackPanel>

        <StackPanel x:Name="Panel4" Width="240" Height="60" HorizontalAlignment="Left" VerticalAlignment="Top" Orientation="Vertical" >
            <RadioButton GroupName="Office" x:Name="Office1" IsChecked="True" VerticalContentAlignment="Center" Height="20" >
                <TextBlock Foreground="White" Text="Geen Office" />
            </RadioButton>
            <RadioButton GroupName="Office" x:Name="Office2" VerticalContentAlignment="Center" Height="20" >
                <TextBlock Foreground="White" Text="Microsoft Office 2013" />
            </RadioButton>
            <RadioButton GroupName="Office" x:Name="Office3" VerticalContentAlignment="Center" Height="20" >
                <TextBlock Foreground="White" Text="Microsoft Office 2016" />
            </RadioButton>
        </StackPanel>

        <Button x:Name="CloseButton" Style="{StaticResource ButtonStyle}" Content="Start" HorizontalAlignment="Center" VerticalAlignment="Bottom" Width="120" Height="30" />
        <Button x:Name="RestartButton" Style="{StaticResource ButtonStyle}" Content="Restart" HorizontalAlignment="Center" VerticalAlignment="Bottom" Width="120" Height="30" />

    </Grid>
</Window>
"@


# Background Politie #0a3b76
#===========================================================================
# Defines XAML and Nodes loading
#===========================================================================

$InputXAML = $InputXAML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
[xml]$xaml = $InputXAML
$Reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Form=[Windows.Markup.XamlReader]::Load($Reader)
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name $($_.Name) -Value $Form.FindName($_.Name)}

#===========================================================================
# Defines Image
#===========================================================================

$Base64 = "iVBORw0KGgoAAAANSUhEUgAAAOoAAADqCAYAAACslNlOAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAGYktHRAD/AP8A/6C9p5MAAAAJdnBBZwAAA3AAAAKUADmxMSUAAAAldEVYdGRhdGU6Y3JlYXRlADIwMTQtMDYtMTdUMDM6NDE6MDktMDc6MDD9nB7vAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE0LTA2LTE3VDAzOjQxOjA5LTA3OjAwjMGmUwAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAAhdEVYdENyZWF0aW9uIFRpbWUAMjAxNzoxMDoyMiAxNToxNTowNe6sA8oAAAOTSURBVHhe7dqtbhRhFIDhmSUNqWgaBBLJBRQUgkuoKUHUgCQVJFgSkhZwXEAdAoOi4Q4IV4BEFweCv/DjmGUbRi+WNzxPspk5X8advMmKb5ymaX94/WR/oGdr88dw9e69xWLxYT5Za7Xra5+G4/vzSMhZqIffblw6mmdCtjbGL+PmuZ3x2bvT+WitaXqw9+jNi5N5JGQxP4F/mFAhQKgQIFQIECoECBUChAoBQoUAoUKAUCFAqBAgVAgQKgQIFQKECgFChQChQoBQIUCoECBUCBAqBAgVAoQKAUKFAKFCgFAhQKgQIFQIECoECBUChAoBQoUAoUKAUCFAqBAgVAgQKgQIFQKECgFChQChQoBQIUCoECBUCBAqBAgVAoQKAUKFAKFCgFAhQKgQIFQIECoECBUChAoBQoUAoUKAUCFAqBAgVAgQKgQIFQKECgFChQChQoBQIUCoECBUCBAqBAgVAoQKAUKFAKFCgFAhQKgQIFQIECoECBUChAoBQoUAoUKAUCFAqBAgVAgQKgQIFQKECgFChQChQoBQIUCoECBUCBAqBAgVAoQKAUKFAKFCgFAhQKgQIFQIECoECBUChAoBQoUAoUKAUCFAqBAgVAgQKgSM0zTdGg4u355nSs4vvo8XNu6MD9++n0/Wmqbj68+Hp0fzCAAAAAAAAAAAwH9tXC6X4+jOb9VyGMdpfv+r5errYbhp10Fnd313V5vbnWdafq5+j4fF4uOfcb1p2t5ZrfxgHgk5C/Vw8fKri9pFW9ufh4vjlWFnPJ1P1pqmzb1fr4aTeSTE3yAIECoECBUChAoBQoUAoUKAUCFAqBAgVAgQKgQIFQKECgFChQChQoBQIUCoECBUCBAqBAgVAoQKAUKFAKFCgFAhQKgQIFQIECoECBUChAoBQoUAoUKAUCFAqBAgVAgQKgQIFQKECgFChQChQoBQIUCoECBUCBAqBAgVAoQKAUKFAKFCgFAhQKgQIFQIECoECBUChAoBQoUAoUKAUCFAqBAgVAgQKgQIFQKECgFChQChQoBQIUCoECBUCBAqBAgVAoQKAUKFAKFCgFAhQKgQIFQIECoECBUChAoBQoUAoUKAUCFAqBAgVAgQKgQIFQKECgFChQChQoBQIUCoECBUCBAqBAgVAoQKAUKFAKFCgFAhQKgQIFQIECoECBUChAoBQoUAoUKAUCFAqBAgVAgQKgQIFQKECgFChX/eMPwGdPVGq4wd6GYAAAAASUVORK5CYII=
"

# Create a streaming image by streaming the base64 string to a bitmap streamsource
$bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$bitmap.BeginInit()
$bitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($base64)
$bitmap.EndInit()
$bitmap.Freeze()
$image1.source = $bitmap
$Image2.source = $bitmap

#===========================================================================
# Defines Placement
#===========================================================================

$Image1.Margin            = "50,25,0,0"
$MenuHeader.Margin        = "0,25,0,0"
$Image2.Margin            = "0,25,50,0"

$HostNameBoxLabel.Margin  = "30,100,0,0"
$HostNameBox.Margin       = "30,125,0,0"
$ModelNumberLabel.Margin  = "30,150,0,0"
$ModelNumber.Margin       = "30,170,0,0"
$SerialNumberLabel.Margin = "30,190,0,0"
$SerialNumber.Margin      = "30,210,0,0"
$RAMInstalledLabel.Margin = "30,230,0,0"
$RAMInstalled.Margin      = "30,250,0,0"

#$TPMFoundLabel.Margin     = "30,270,0,0"
#$TPMFound.Margin          = "30,290,0,0"
#$TPMOwnerLabel.Margin     = "110,270,0,0"
#$TPMOwner.Margin          = "110,290,0,0"
#$OnPowerLabel.Margin      = "190,270,0,0"
#$OnPower.Margin           = "190,290,0,0"

$ComboBoxLabel.Margin     = "330,100,0,0" 
$PresetDropDown.Margin    = "330,125,0,0"
$Panel1.Margin            = "335,155,0,0"
$Panel2.Margin            = "335,180,0,0"
$Panel3.Margin            = "335,205,0,0"
$Panel4.Margin            = "335,235,0,0"
$CloseButton.Margin       = "150,0,0,25"
$RestartButton.Margin     = "0,0,150,25"

#===========================================================================
# Defines options when clicking one of the Type Presets
#===========================================================================

# Defaults
$LanguageCheckBox.IsChecked = $True
$LanguageCheckBox.IsEnabled =$False
$BitLockerCheckBox.IsChecked = $True
$BitLockerCheckBox.IsEnabled = $False
$MBAMCheckBox.IsEnabled = $False
$Branch2.IsChecked = $True
$Branch1.IsEnabled = $False
$Branch2.IsEnabled = $False
$Office1.IsChecked = $True
$Office1.IsEnabled = $False
$Office2.IsEnabled = $False
$Office3.IsEnabled = $False

$PresetDropDown.Add_SelectionChanged(
    {
    # Sets checkboxes corresponding with the selected preset
    if ($PresetDropDown.SelectedItem.Content -eq "Laptop_Type_Bitlocker") {
        $LanguageCheckBox.IsChecked =$True
        $LanguageCheckBox.IsEnabled =$False
        $BitLockerCheckBox.IsChecked = $True
        $BitLockerCheckBox.IsEnabled = $False
        $MBAMCheckBox.IsChecked = $False
        $MBAMCheckBox.IsEnabled = $False
        $Branch2.IsChecked = $True
        $Branch2.IsEnabled = $False
        $Office1.IsChecked = $True
        $Office1.IsEnabled =$False
    } elseif ($PresetDropDown.SelectedItem.Content -eq "Laptop_Type_MBAM") {
        $LanguageCheckBox.IsChecked =$True
        $MBAMCheckBox.IsChecked = $True
        $Branch2.IsChecked = $True
        $Office1.IsChecked = $True
    } elseif ($PresetDropDown.SelectedItem.Content -eq "Laptop_Type_3") {
        $LanguageCheckBox.IsEnabled =$True
        $BitLockerCheckBox.IsEnabled = $True
        $MBAMCheckBox.IsEnabled = $True
        $Branch1.IsEnabled = $True
        $Branch2.IsEnabled = $True
        $Office1.IsEnabled = $True
        $Office2.IsEnabled = $True
        $Office3.IsEnabled = $True
    } elseif ($PresetDropDown.SelectedItem.Content -eq "Desktop_Type_4") {
        $LanguageCheckBox.IsChecked =$False
        $BitLockerCheckBox.IsEnabled = $False
        $BitLockerCheckBox.IsChecked = $False
        $MBAMCheckBox.IsChecked = $False
        $MBAMCheckBox.IsEnabled = $False
        $Branch1.IsChecked = $True
        $Office1.IsChecked = $True
    }elseif ($PresetDropDown.SelectedItem.Content -eq "Test") {
        $LanguageCheckBox.IsChecked =$False
        $BitLockerCheckBox.IsEnabled = $True
        $BitLockerCheckBox.IsChecked = $False
        $MBAMCheckBox.IsChecked = $False
        $MBAMCheckBox.IsEnabled = $True
        $Branch1.IsChecked = $True
        $Office1.IsChecked = $True
    }elseif ($PresetDropDown.SelectedItem.Content -eq "") {
        $LanguageCheckBox.IsChecked =$False
        $BitLockerCheckBox.IsEnabled = $True
        $BitLockerCheckBox.IsChecked = $False
        $MBAMCheckBox.IsChecked = $False
        $MBAMCheckBox.IsEnabled = $True
        $Branch1.IsChecked = $True
        $Office1.IsChecked = $True
    }
    }
)

#===========================================================================
# Defines the Test FrontEnd
#===========================================================================

If ($Script:PSBoundParameters["DebugFrontEnd"])
{

$item = New-Object -TypeName "System.Windows.Controls.ComboBoxItem" 
$item.Content = "Test" 
$item.ToolTip = "This is tooltip for Test"

$PresetDropDown.Items.Insert(0,$item)
#$PresetDropDown.AddChild($item)

$LanguageCheckBox.IsChecked = $False
$BitLockerCheckBox.IsChecked = $False
$BitLockerCheckBox.IsEnabled = $True
$MBAMCheckBox.IsChecked = $False
$MBAMCheckBox.IsEnabled = $True
$Office1.IsChecked = $False
$Branch2.IsChecked = $False
}

#===========================================================================
# Defines System Information from WMI
#===========================================================================

$ModelNumber.Content = (gwmi -Class Win32_ComputerSystem).Manufacturer + " " + (gwmi -Class Win32_ComputerSystem).SystemFamily
$SerialNumber.Content = (gwmi -Class Win32_BIOS).SerialNumber
$RAMInstalled.Content = ([math]::Round((gwmi -Class Win32_ComputerSystem).TotalPhysicalMemory / (1024 * 1024 * 1024))).ToString() + " GB (" + ([math]::Round(((gwmi -Class Win32_ComputerSystem).TotalPhysicalMemory / (1024 * 1024 * 1024)),2)).ToString() + " GB avail.)"
#$HostNameBox.Text = (gwmi -Class Win32_ComputerSystem).Name
$HostNameEnd = (gwmi -Class Win32_BIOS).SerialNumber
$HostNameBox.Text = "BUILD" + "-" + $($HostNameEnd.substring($HostNameEnd.length – 6, 6) -replace "-")
$HostNameBox.MaxLength = 15

<#
if ((gwmi -namespace root\cimv2\Security\MicrosoftTPM -Class Win32_TPM).IsEnabled_InitialValue -eq $null ){
    $IsTPMEnabled = $False
    $TPMFound.Background = "Red"
} else {
    $IsTPMEnabled = (gwmi -namespace root\cimv2\Security\MicrosoftTPM -Class Win32_TPM).IsEnabled_InitialValue
    $TPMFound.Background = "Green"
}

if (((gwmi -namespace root\cimv2\Security\MicrosoftTPM -Class Win32_TPM).IsOwned_InitialValue -eq $null) -or ((gwmi -namespace root\cimv2\Security\MicrosoftTPM -Class Win32_TPM).IsOwned_InitialValue -eq $False)) {
    $IsTPMOwner = $False
    $TPMOwner.Background = "Red"
} else {
    $IsTPMOwner = (gwmi -namespace root\cimv2\Security\MicrosoftTPM -Class Win32_TPM).IsOwned_InitialValue
    $TPMOwner.Background = "Green"
}

If ((gwmi -Namespace root\WMI -Class BatteryStatus).PowerOnline -eq $False){
    $OnPower.Background = "Red"
    $IsOnPower = $False
} else {
    $OnPower.Background = "Green"
    $IsOnPower = $True
}
#>

#===========================================================================
# Defines Closebutton Actions
#===========================================================================

$CloseButton.Add_Click({

#
$TSEnv.Value("OSDComputerName") = $HostNameBox.Text
$TSEnv.Value("OSDNederlands")   = $LanguageCheckBox.IsChecked
$TSEnv.Value("OSDBitLocker")    = $BitLockerCheckBox.IsChecked
$TSEnv.Value("OSDMBAM")         = $MBAMCheckBox.IsChecked
$TSEnv.Value("OSDPilot")        = $Branch1.IsChecked
$TSEnv.Value("OSDProduction")   = $Branch2.IsChecked
$TSEnv.Value("OSDNoOffice")     = $Office1.IsChecked
$TSEnv.Value("OSDOffice2013")   = $Office2.IsChecked
$TSEnv.Value("OSDOffice2016")   = $Office3.IsChecked
$TSEnv.Value("OSDTPMEnabled")   = $IsTPMFound
$TSEnv.Value("OSDTPMOwner")     = $IsTPMOwner
$TSEnv.Value("OSDType")         = $PresetDropDown.SelectedItem.Content
#

If ($Script:PSBoundParameters["DebugFrontEnd"])
{

[System.Windows.MessageBox]::Show(
"
OSDComputerName = $($HostNameBox.text)
OSDType = $($PresetDropDown.SelectedItem.Content)
OSDNederlands = $($LanguageCheckBox.IsChecked)
OSDBitLocker = $($BitLockerCheckBox.IsChecked)
OSDMBAM = $($MBAMCheckBox.IsChecked)
OSDPilot = $($Branch1.IsChecked)
OSDProduction = $($Branch2.IsChecked)
OSDNoOffice = $($Office1.IsChecked)
OSDOffice2013 = $($Office2.IsChecked)
OSDOffice2016 = $($Office3.IsChecked)
OSDTPMEnabled =  $IsTPMEnabled
OSDTPMOwner = $IsTPMOwner
"
)
}

$Form.Close()

})

$RestartButton.Add_Click({

Restart-Computer

})

#===========================================================================
# Defines options for Task Sequence
#===========================================================================

# Objects for interacting with Task Sequence environment
$TSEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$TSProgressUI = New-Object -COMObject Microsoft.SMS.TSProgressUI

# Pre-populates PC name text box with last known SCCM client name if available
#$HostNameBox.Text = $TSEnv.Value("_SMSTSMachineName")

# Hides Task Sequence progress bar until the menu exits and process resumes
$TSProgressUI.CloseProgressDialog()
$TSProgressUI = $null
#

#===========================================================================
# Defines Selected Type
#===========================================================================

$PresetDropDown.SelectedIndex = 0

#===========================================================================
# Defines the Final Show Form
#===========================================================================

#$Form.FindName('Grid').Add_MouseLeftButtonDown({$Form.DragMove()})

#$CloseButton.focus() >>$null

$HostNameBox.focus() >>$Null

#$Form.Add_Shown({$Form.Activate(); $CloseButton.focus()})

#$Form.Activate()

$Form.ShowDialog() | Out-Null