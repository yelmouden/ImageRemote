ImageRemote
===========

Classes permettant de downloader des images depuis un serveur (+ cache)

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
    UILabel * label = (UILabel *)[cell viewWithTag:2];
    label.text = ((Item *)[_arrayItems objectAtIndex:indexPath.row]).titre;
    
    UIImageView * img = (UIImageView *)[cell viewWithTag:1];
    [img setImageFromUrl:item.url placeholderImage:nil withIndicator:YES doesCacheImage:NO];
    
    return cell;
}
