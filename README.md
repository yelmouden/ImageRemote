ImageRemote
===========

Classes for downloading remote images ( Available in iOS 4.3 and later.).

By downloading this classes, you can easily download an image from a server with one line of code:
    
    UIImageView * img = //allocation;
    [img setImageFromUrl:@"url" placeholderImage:[UIImage imageNamed:@"placeholder.png"] withIndicator:YES doesCacheImage:NO];

Features :

All the downloaded images are cached in memory.

All cached images are freed in low memory condition.

Possibility to save the image on the disk.

Easy to use in tableViews for remote images :
    
    
    
    
        - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
        {
            static NSString *CellIdentifier = @"idItem";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"CellItem" owner:self options:nil];
                cell = _cellItem;
                self.cellItem = nil;
            }
            
            // Configure the cell...
            Item * item = [_arrayItems objectAtIndex:indexPath.row];
            UIImageView * img = (UIImageView *)[cell viewWithTag:1];
            //dowload the image
            [img setImageFromUrl:item.url placeholderImage:[UIImage imageNamed:@"placeholder.png"] withIndicator:YES doesCacheImage:NO];
    
            return cell;
}
