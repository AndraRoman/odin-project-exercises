module MoveValidationHelpers
  
  # history only needed for en passant
  def threatened?(square, sign, board, history)
    board.each_with_index do |row, y|
      row.each_with_index do |piece, x|
        if !piece.nil? && piece * sign < 0
           if piece.abs == 6 # special case to prevent infinite loop between kings
             return true if validate_direct_king_move([x, y], square, board)
           else
             return true if validate_move([x, y], square, board, sign * -1, history)
           end
        end
      end
    end
    false
  end
  
  # passes empty history to threatened? since it won't affect the outcome
  def check?(sign, board)
    square = [0, 0]
    board.each_with_index do |row, y|
      row.each_with_index do |piece, x|
        if piece == 6 * sign
          square = [x, y]
          break
        end
      end
    end
    threatened?(square, sign, board, [])
  end
end

module PieceMoveValidations

  include MoveValidationHelpers
  
  def validate_pawn_move(start, finish, board)
    difference = delta(start, finish)
    piece = board.get_by_coords(start)
    other_piece = board.get_by_coords(finish)
    if other_piece.nil?
      if difference == [0, piece]
        true
      elsif difference == [0, 2 * piece]
        [3, 8].include? start[1] # must be in rank 2 or 7 to move two squares
      else
        other_piece = board.get_by_coords([finish[0], finish[1] - piece])
      [finish[0], finish[1] - piece] if other_piece == -1 * piece && (difference[0]).abs == 1 && piece * other_piece < 0 # en passant
      end
    elsif piece * other_piece > 0
      false
    else
      finish if (difference[0]).abs == 1 && difference[1] == piece # normal capture
    end
  end

  def validate_knight_move(start, finish)
    difference = delta(start, finish)
    (difference[0] * difference[1]).abs == 2
  end
  
  def validate_bishop_move(start, finish)
    difference = delta(start, finish)
    difference[0].abs == difference[1].abs
  end
  
  def validate_rook_move(start, finish)
    difference = delta(start, finish)
    difference.include?(0)
  end
  
  def validate_queen_move(start, finish)
    validate_rook_move(start, finish) || validate_bishop_move(start, finish)
  end
  
  # king/rook position validation is done in calling fn, using history
  def validate_king_move(start, finish, board)
    difference = delta(start, finish)
    piece = board.get_by_coords(start)
    squares_passed_through = path(start, finish)
    squares_passed_through.each do |square|
      return false if threatened?(square, piece / piece.abs, board, [])
    end
    if validate_direct_king_move(start, finish, board)
      true
    else
      if check?(piece / piece.abs, board)
        false
      elsif difference == [2, 0]
        board.path_open?(path(start, [10, start[1]]))
      elsif difference == [-2, 0]
        board.path_open?(path(start, [2, start[1]]))
      else
        false
      end
    end
  end
  
  def validate_direct_king_move(start, finish, board)
    difference = delta(start, finish)
    difference.none? { |i| i.abs > 1 } && difference.any? { |i| i != 0 }
  end

end

module MoveValidations

  include PieceMoveValidations

  # returns false if invalid, coordinates of captured piece if valid and capture is made, else true
  def validate_move(start, finish, board, player_sign, history)
    piece = board.get_by_coords(start)
    target_piece = board.get_by_coords(finish)
  
    captured_piece_coords = nil
  
    basic_validation_result = validate_move_basics(piece, target_piece, start, finish, board, player_sign)
    if basic_validation_result
      captured_piece_coords = basic_validation_result if basic_validation_result.class == Array
    else
      return false
    end
  
    piece_validation_result = validate_move_by_piece(piece, start, finish, board)
    if piece_validation_result
      captured_piece_coords = piece_validation_result if piece_validation_result.class == Array # en passant
    else
      return false
    end
  
    return false unless validate_move_by_history(piece, start, finish, board, history)
    return false unless validate_not_left_in_check(piece, start, finish, board)
  
    captured_piece_coords || true
  end
  
  # TODO test
  def validate_move_basics(piece, target_piece, start, finish, board, player_sign)
    return false unless (!piece.nil? && piece * player_sign > 0) # starting point has a piece of the correct color
    return false if target_piece == 0 # out of bounds
    path = path(start, finish)
    return false unless board.path_open?(path)
    return false if !target_piece.nil? && piece * target_piece > 0 # can't capture own piece
    !target_piece.nil? ? finish : true # captured piece coords or true
  end
  
  # TODO test
  def validate_move_by_piece(piece, start, finish, board)
    case piece.abs
    when 1 then validate_pawn_move(start, finish, board)
    when 2 then validate_knight_move(start, finish)
    when 3 then validate_bishop_move(start, finish)
    when 4 then validate_rook_move(start, finish)
    when 5 then validate_queen_move(start, finish)
    when 6 then validate_king_move(start, finish, board)
    end
  end
  
  # TODO
  def validate_move_by_history(piece, start, finish, board, history)
    true
  end
  
  # TODO
  # piece not needed - just used to get player sign
  def validate_not_left_in_check(piece, start, finish, board)
    true
  end
end

