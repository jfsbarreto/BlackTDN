#requires -version 2.0
function Add-OverlayFilter {    
    <#
        .Synopsis
            Adds an Overlay Filter to a list of filters, or creates a new filter
        .Description
            Adds an Overlay Filter to a list of filters, or creates a new filter
        .Example
            $image = Get-Image .\Try.jpg
            $otherImage = Get-Image .\OtherImage.jpg            
            $image = $image | Set-ImageFilter -filter (Add-OverLayFilter -Image $otherImage -Left 10 -Top 10 -passThru) -passThru                    
            $image.SaveFile("$pwd\Try2.jpg")
        .Parameter image
            Optional.  If set, allows you to specify the crop in terms of a percentage
        .Parameter left
            The horizontal location within the image where the overlay should be added 
        .Parameter top
            The vertical location within the image where the overlay should be added
        .Parameter passthru
            If set, the filter will be returned through the pipeline.  This should be set unless the filter is saved to a variable.
        .Parameter filter
            The filter chain that the rotate filter will be added to.  If no chain exists, then the filter will be created
    #>

    param(
    [Parameter(ValueFromPipeline=$true)]
    [__ComObject]
    $filter,
    
    [__ComObject]
    $image,
        
    [Double]$left,
    [Double]$top,
    
    [switch]$passThru                      
    )
    
    process {
        if (-not $filter) {
            $filter = New-Object -ComObject Wia.ImageProcess
        } 
        $index = $filter.Filters.Count + 1
        if (-not $filter.Apply) { return }
        $stamp = $filter.FilterInfos.Item("Stamp").FilterId                    
        $filter.Filters.Add($stamp)
        $filter.Filters.Item($index).Properties.Item("ImageFile") = $image.PSObject.BaseObject
        $filter.Filters.Item($index).Properties.Item("Left") = $left
        $filter.Filters.Item($index).Properties.Item("Top") = $top
        if ($passthru) { return $filter }         
    }
}